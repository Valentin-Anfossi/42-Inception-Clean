# Create secrets files
mkdir ./secrets
echo "========== CREATING SECRETS FILES =========="
if [ ! -f ./secrets/sql_credentials.txt ]; then
    echo "Creating sql_credentials.txt..."
    echo "SQL_ROOT_PASSWORD ?"
    read -r value
    echo "SQL_ROOT_PASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_USER ?"
    read -r value
    echo "SQL_USER=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_PASSWORD ?"
    read -r value
    echo "SQL_PASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_ADMIN ?"
    read -r value
    echo "SQL_ADMIN=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_ADMINPASSWORD ?"
    read -r value
    echo "SQL_ADMINPASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "sql_credentials.txt created."
fi

if [ ! -f ./secrets/wp_credentials.txt ]; then
    echo "Creating wp_credentials.txt..."
    echo "WP_ADMIN_USER ?"
    read -r value
    echo "WP_ADMIN_USER=$value" >> ./secrets/wp_credentials.txt
    echo "WP_ADMIN_PASSWORD ?"
    read -r value
    echo "WP_ADMIN_PASSWORD=$value" >> ./secrets/wp_credentials.txt
    echo "WP_ADMIN_EMAIL ?"
    read -r value
    echo "WP_ADMIN_EMAIL=$value" >> ./secrets/wp_credentials.txt
    echo "wp_credentials.txt created."
fi