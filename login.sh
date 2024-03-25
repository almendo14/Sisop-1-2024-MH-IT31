# Function to decrypt password from base64
decrypt_password() {
    echo "$1" | base64 --decode
}

# Function to check if user exists and verify password
verify_user() {
    if grep -q "^$1:" users.txt; then
        user_data=$(grep "^$1:" users.txt)
        stored_password=$(echo "$user_data" | cut -d: -f5)
        decrypted_password=$(decrypt_password "$stored_password")
        if [ "$2" = "$decrypted_password" ]; then
            return 0 # Password is correct
        else
            return 1 # Password is incorrect
        fi
    else
        return 2 # User does not exist
    fi
}

# Function to retrieve security question for password recovery
get_security_question() {
    if grep -q "^$1:" users.txt; then
        user_data=$(grep "^$1:" users.txt)
        security_question=$(echo "$user_data" | cut -d: -f3)
        echo "$security_question"
    else
        echo "User not found."
    fi
}

# Function to validate security answer for password recovery
validate_security_answer() {
    if grep -q "^$1:" users.txt; then
        user_data=$(grep "^$1:" users.txt)
        stored_security_answer=$(echo "$user_data" | cut -d: -f4)
        if [ "$2" = "$stored_security_answer" ]; then
            return 0 # Security answer is correct
        else
            return 1 # Security answer is incorrect
        fi
    else
        return 2 # User does not exist
    fi
}

# Main login process
echo "Welcome to Login System"
read -p "Enter your email: " email
read -s -p "Enter your password: " password
echo

if verify_user "$email" "$password"; then
    timestamp=$(date +"%d/%m/%Y %T")
    echo "[$timestamp] [LOGIN SUCCESS] User with email $email logged in successfully" >> auth.log
    echo "Login successful. Welcome, $email!"
else
    echo "Login failed. Invalid email or password."
    read -p "Forgot password? (yes/no): " forgot_password
    case $forgot_password in
        yes|Yes|YES)
            security_question=$(get_security_question "$email")
            echo "Security Question: $security_question"
            read -p "Answer: " answer
            if validate_security_answer "$email" "$answer"; then
                user_data=$(grep "^$email:" users.txt)
                stored_password=$(echo "$user_data" | cut -d: -f5)
                decrypted_password=$(decrypt_password "$stored_password")
                echo "Your password is: $decrypted_password"
            else
                echo "Incorrect answer."
            fi
            ;;
        *)
            ;;
    esac
fi
