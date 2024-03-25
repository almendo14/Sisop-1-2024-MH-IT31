# Function to encrypt password using base64
encrypt_password() {
    echo -n "$1" | base64
}

# Function to check if email already exists in users.txt
check_existing_email() {
    if grep -q "^$1:" users.txt; then
        return 0 # Email exists
    else
        return 1 # Email does not exist
    fi
}

# Function to validate password
validate_password() {
    # Regex patterns for password validation
    contains_capital=$(echo "$1" | grep '[A-Z]')
    contains_lowercase=$(echo "$1" | grep '[a-z]')
    contains_number=$(echo "$1" | grep '[0-9]')

    if [ ${#1} -lt 8 ]; then
        return 1 # Password length less than 8 characters
    elif [ -z "$contains_capital" ] || [ -z "$contains_lowercase" ] || [ -z "$contains_number" ]; then
        return 2 # Password does not meet complexity requirements
    else
        return 0 # Password meets requirements
    fi
}

# Main registration process
echo "Welcome to Registration System"
read -p "Enter your email: " email
read -p "Enter your username: " username

# Check if email already exists
if check_existing_email "$email"; then
    echo "Email already exists. Please choose a different email."
    exit 1
fi

# Determine if the user is an admin
if echo "$email" | grep -q "admin"; then
    is_admin="true"
else
    is_admin="false"
fi

read -p "Enter your security question: " security_question
read -p "Enter your answer to the security question: " security_answer

# Validate password
while true; do
    read -s -p "Enter your password (minimum 8 characters, at least 1 uppercase letter, 1 lowercase letter, 1 digit, 1 symbol, and not same as username, birthdate, or name): " password
    echo
    validate_password "$password"
    case $? in
        0)
            encrypted_password=$(encrypt_password "$password")
            break
            ;;
        1)
            echo "Password must be at least 8 characters long."
            ;;
        2)
            echo "Password must contain at least one uppercase letter, one lowercase letter, and one number."
            ;;
    esac
done

# Store user data in users.txt
echo "$email:$username:$security_question:$security_answer:$encrypted_password:$is_admin" >> users.txt

# Log registration
timestamp=$(date +"%d/%m/%Y %T")
echo "[$timestamp] [REGISTER SUCCESS] User $username registered successfully" >> auth.log

echo "User registration successfully!"
