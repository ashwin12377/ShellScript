#!/bin/bash
#Ashwin👋

# Set the IAM user name to delete
read -p "Enter the IAM username 🤡: " BASE_USER_NAME
USER_NAME="${BASE_USER_NAME}"

# Detach all managed policies attached to the user
echo "Detaching all managed policies from user '$USER_NAME'..."
POLICIES=$(aws iam list-attached-user-policies --user-name $USER_NAME --query 'AttachedPolicies[].PolicyArn' --output text)
for POLICY_ARN in $POLICIES; do
    aws iam detach-user-policy --user-name $USER_NAME --policy-arn $POLICY_ARN
    echo "🙊Detached policy: $POLICY_ARN"
done

echo ""
# Delete all inline policies associated with the user
echo "🤓Deleting all inline policies from user '$USER_NAME'..."
INLINE_POLICIES=$(aws iam list-user-policies --user-name $USER_NAME --query 'PolicyNames' --output text)
for POLICY_NAME in $INLINE_POLICIES; do
    aws iam delete-user-policy --user-name $USER_NAME --policy-name $POLICY_NAME
    echo "Deleted inline policy: $POLICY_NAME"
done

echo ""
# Delete any access keys associated with the user
echo "🤓Deleting all access keys for user '$USER_NAME'..."
ACCESS_KEYS=$(aws iam list-access-keys --user-name $USER_NAME --query 'AccessKeyMetadata[].AccessKeyId' --output text)
for ACCESS_KEY in $ACCESS_KEYS; do
    aws iam delete-access-key --user-name $USER_NAME --access-key-id $ACCESS_KEY
    echo "Deleted access key: $ACCESS_KEY"
done

echo ""
# Delete the login profile (if any) associated with the user
echo "🤓Deleting login profile for user '$USER_NAME' (if exists)..."
aws iam delete-login-profile --user-name $USER_NAME 2>/dev/null && echo "Deleted login profile"

# Delete any SSH public keys associated with the user
echo "🤓Deleting all SSH public keys for user '$USER_NAME'..."
SSH_KEYS=$(aws iam list-ssh-public-keys --user-name $USER_NAME --query 'SSHPublicKeys[].SSHPublicKeyId' --output text)
for SSH_KEY in $SSH_KEYS; do
    aws iam delete-ssh-public-key --user-name $USER_NAME --ssh-public-key-id $SSH_KEY
    echo "Deleted SSH public key: $SSH_KEY"
done

# Remove the user from any groups
echo "👋Removing user '$USER_NAME' from all groups..."
GROUPS=$(aws iam list-groups-for-user --user-name $USER_NAME --query 'Groups[].GroupName' --output text)
for GROUP in $GROUPS; do
    aws iam remove-user-from-group --user-name $USER_NAME --group-name $GROUP
    echo "🦵Removed user from group: $GROUP"
done

echo ""
# Finally, delete the IAM user
echo "Deleting IAM user '$USER_NAME'..."
aws iam delete-user --user-name $USER_NAME
if [ $? -eq 0 ]; then
    echo "💥Boom! IAM user: '$USER_NAME'💩 deleted successfully✅"
else
    echo "Failed to delete IAM user '$USER_NAME'❌"
fi
