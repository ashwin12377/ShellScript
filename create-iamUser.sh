#!/bin/bash
# Ashwin👋

# Prompt for the base username
read -p "Enter the IAM username 🤡: " BASE_USER_NAME

# Combine the base username with the suffix to create the username and password
SUFFIX="@AWS12345"
USER_NAME="${BASE_USER_NAME}"
PASSWORD="${BASE_USER_NAME}${SUFFIX}"

Account_Alias="https://ashwin369.signin.aws.amazon.com/console"

POLICIES=(
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    "arn:aws:iam::aws:policy/IAMUserChangePassword"
)

SUFFIX2="_credentials.txt"
OUTPUT_FILE="${USER_NAME}${SUFFIX2}"  # File to save access keys

# Check if the exact user exists
EXISTING_USER=$(aws iam get-user --user-name $USER_NAME --query 'User.UserName' --output text 2>/dev/null)
if [ "$EXISTING_USER" == "$USER_NAME" ]; then
    echo "IAM user '$USER_NAME' already exists❌"
    exit 1
fi

# List all users and check for case-insensitive name matches
EXISTING_USERS=$(aws iam list-users --query "Users[].UserName" --output text)
for EXISTING_USER in $EXISTING_USERS; do
    if [ "$(echo $EXISTING_USER | tr '[:upper:]' '[:lower:]')" == "$(echo $USER_NAME | tr '[:upper:]' '[:lower:]')" ]; then
        echo "IAM user '$EXISTING_USER' already exists (case-insensitive match)❌"
        exit 1
    fi
done

# Create the IAM user
aws iam create-user --user-name $USER_NAME
if [ $? -ne 0 ]; then
    echo "Failed to create IAM user❌"
    exit 1
fi
echo "IAM user '$USER_NAME' created successfully✅"
echo ""

# Wait a few seconds to ensure the user is created
sleep 2

# Create a login profile for the user with the specified password
aws iam create-login-profile --user-name $USER_NAME --password $PASSWORD --password-reset-required
if [ $? -ne 0 ]; then
    echo "Failed to create login profile for IAM user ❌"
    exit 1
fi
echo "IAM user '$USER_NAME' created with password '$PASSWORD'✅"
echo ""

# Attach each policy to the user
for POLICY_ARN in "${POLICIES[@]}"; do
    aws iam attach-user-policy --user-name $USER_NAME --policy-arn $POLICY_ARN
    if [ $? -ne 0 ]; then
        echo "Failed to attach policy: $POLICY_ARN ❌"
        exit 1
    fi
    echo "Policy $POLICY_ARN attached to '$USER_NAME' successfully✅"
done
echo ""

# Create access keys for the user
ACCESS_KEYS=$(aws iam create-access-key --user-name $USER_NAME --query 'AccessKey.{AccessKeyId:AccessKeyId,SecretAccessKey:SecretAccessKey}' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create access keys ❌"
    exit 1
fi
echo ""

# Extract AccessKeyId and SecretAccessKey
ACCESS_KEY_ID=$(echo $ACCESS_KEYS | awk '{print $1}')
SECRET_ACCESS_KEY=$(echo $ACCESS_KEYS | awk '{print $2}')
echo ""

# Display the access keys in the terminal
echo "Access keys created: 🔑"
echo "AccessKeyId: $ACCESS_KEY_ID"
echo "SecretAccessKey: $SECRET_ACCESS_KEY"
echo ""

# Save the credentials to the file
echo "Account alias: $Account_Alias" > $OUTPUT_FILE
echo "User_Name: $USER_NAME" >> $OUTPUT_FILE
echo "Password: $PASSWORD" >> $OUTPUT_FILE
echo "AccessKeyId: $ACCESS_KEY_ID" >> $OUTPUT_FILE
echo "SecretAccessKey: $SECRET_ACCESS_KEY" >> $OUTPUT_FILE
echo ""

echo "Ta-daaaah 🎉 IAM user '$USER_NAME' 🤡created, credentials saved to '$OUTPUT_FILE' ✅"

