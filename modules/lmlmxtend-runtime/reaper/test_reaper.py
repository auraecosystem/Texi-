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


def test_terminate_expired_instances_only_terminates_past_ttl():
    now = datetime(2026, 11, 27, 12, 0, tzinfo=timezone.utc)
    mock_ec2 = MagicMock()
    mock_ec2.describe_instances.return_value = {
        "Reservations": [
            {
                "Instances": [
                    {
                        "InstanceId": "i-expired",
                        "Tags": [{"Key": "ExpiresAt", "Value": (now - timedelta(hours=1)).isoformat()}],
                    },
                    {
                        "InstanceId": "i-active",
                        "Tags": [{"Key": "ExpiresAt", "Value": (now + timedelta(hours=4)).isoformat()}],
                    },
                ]
            }
        ]
    }

    terminated = terminate_expired_instances(mock_ec2, now=now)

    assert terminated == ["i-expired"]
    mock_ec2.terminate_instances.assert_called_once_with(InstanceIds=["i-expired"])
