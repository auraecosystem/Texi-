from datetime import datetime, timedelta, timezone
from unittest.mock import MagicMock

from index import is_expired, terminate_expired_instances


def test_is_expired_true_when_past():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    past = (now - timedelta(minutes=5)).isoformat()
    assert is_expired(past, now=now) is True


def test_is_expired_false_when_future():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    future = (now + timedelta(hours=2)).isoformat()
    assert is_expired(future, now=now) is False


def test_naive_expiry_is_treated_as_utc():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    assert is_expired("2026-11-27T11:00:00", now=now) is True


def test_terminate_expired_instances_only_terminates_past_ttl_across_pages():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    mock_ec2 = MagicMock()
    mock_ec2.describe_instances.side_effect = [
        {
            "Reservations": [
                {
                    "Instances": [
                        {
                            "InstanceId": "i-expired",
                            "Tags": [
                                {
                                    "Key": "ExpiresAt",
                                    "Value": (now - timedelta(hours=1)).isoformat(),
                                }
                            ],
                        }
                    ]
                }
            ],
            "NextToken": "page-2",
        },
        {
            "Reservations": [
                {
                    "Instances": [
                        {
                            "InstanceId": "i-active",
                            "Tags": [
                                {
                                    "Key": "ExpiresAt",
                                    "Value": (now + timedelta(hours=4)).isoformat(),
                                }
                            ],
                        }
                    ]
                }
            ]
        },
    ]

    terminated = terminate_expired_instances(mock_ec2, now=now)

    assert terminated == ["i-expired"]
    assert mock_ec2.describe_instances.call_count == 2
    assert mock_ec2.describe_instances.call_args_list[1].kwargs["NextToken"] == "page-2"
    mock_ec2.terminate_instances.assert_called_once_with(InstanceIds=["i-expired"])


def test_no_termination_call_when_no_instances_are_expired():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    mock_ec2 = MagicMock()
    mock_ec2.describe_instances.return_value = {"Reservations": []}

    assert terminate_expired_instances(mock_ec2, now=now) == []
    mock_ec2.terminate_instances.assert_not_called()
