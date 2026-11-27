from datetime import datetime, timezone
import os
from typing import Any

import boto3


def is_expired(expires_at_iso: str, now: datetime | None = None) -> bool:
    current = now or datetime.now(timezone.utc)
    expiry = datetime.fromisoformat(expires_at_iso.replace("Z", "+00:00"))
    if expiry.tzinfo is None:
        expiry = expiry.replace(tzinfo=timezone.utc)
    return current >= expiry


def terminate_expired_instances(
    ec2_client: Any, now: datetime | None = None
) -> list[str]:
    current = now or datetime.now(timezone.utc)
    expired_ids: list[str] = []
    next_token: str | None = None

    while True:
        request: dict[str, Any] = {
            "Filters": [
                {
                    "Name": "instance-state-name",
                    "Values": ["pending", "running", "stopping", "stopped"],
                },
                {"Name": "tag-key", "Values": ["ExpiresAt"]},
            ]
        }
        if next_token:
            request["NextToken"] = next_token

        response = ec2_client.describe_instances(**request)
        for reservation in response.get("Reservations", []):
            for instance in reservation.get("Instances", []):
                tags = {tag["Key"]: tag["Value"] for tag in instance.get("Tags", [])}
                expires_at = tags.get("ExpiresAt")
                if expires_at and is_expired(expires_at, current):
                    expired_ids.append(instance["InstanceId"])

        next_token = response.get("NextToken")
        if not next_token:
            break

    if expired_ids:
        ec2_client.terminate_instances(InstanceIds=expired_ids)

    return expired_ids


def handler(event: dict[str, Any], context: Any) -> dict[str, Any]:
    ec2_client = boto3.client("ec2")
    terminated = terminate_expired_instances(ec2_client)
    return {
        "statusCode": 200,
        "ttlHours": int(os.environ.get("TTL_HOURS", "24")),
        "terminatedInstances": terminated,
    }
