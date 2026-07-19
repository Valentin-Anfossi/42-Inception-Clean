# Create secrets files
echo "========== CREATING SECRETS FILES =========="
if [ ! -f ./sql_credentials.txt ]; then
    echo "Creating sql_credentials.txt..."
    echo "SQL_ROOT_PASSWORD ?"
    read -r value
    echo "SQL_ROOT_PASSWORD=$value" >> ./sql_credentials.txt
    echo "SQL_USER ?"
    read -r value
    echo "SQL_USER=$value" >> ./sql_credentials.txt
    echo "SQL_PASSWORD ?"
    read -r value
    echo "SQL_PASSWORD=$value" >> ./sql_credentials.txt
    echo "SQL_ADMIN ?"
    read -r value
    echo "SQL_ADMIN=$value" >> ./sql_credentials.txt
    echo "SQL_ADMINPASSWORD ?"
    read -r value
    echo "SQL_ADMINPASSWORD=$value" >> ./sql_credentials.txt
    echo "sql_credentials.txt created."
else
    echo "sql_credentials.txt already exists."
fi

if [ ! -f ./wp_credentials.txt ]; then
    echo "Creating wp_credentials.txt..."
    echo "WP_ADMIN_USER ?"
    read -r user
    echo "WP_ADMIN_USER=$user" >> ./wp_credentials.txt
    echo "WP_ADMIN_PASSWORD ?"
    read -r value
    echo "WP_ADMIN_PASSWORD=$value" >> ./wp_credentials.txt
    echo "WP_ADMIN_EMAIL=$user@42.student.fr" >> ./wp_credentials.txt
    echo "wp_credentials.txt created."
else
    echo "wp_credentials.txt already exists."
fi

if [ ! -f ./ftp_credentials.txt ]; then
    echo "Creating ftp_credentials.txt..."
    echo "FTP_USER ?"
    read -r value
    echo "FTP_USER=$user" >> ./ftp_credentials.txt
    echo "FTP_PASSWORD ?"
    read -r value
    echo "FTP_PASSWORD=$value" >> ./ftp_credentials.txt
else
    echo "ftp_credentials.txt already exists."
fi

if [ ! -f ./cockpit_credentials.txt ]; then
    echo "Creating cockpit_credentials.txt..."
    echo "COCKPIT USER ?"
    read -r value
    echo "COCKPIT_USER=$value" >> ./cockpit_credentials.txt
    echo "COCKPIT PASSWORD ?"
    read -r value
    echo "COCKPIT_PASSWORD=$value" >> ./cockpit_credentials.txt
else
    echo "cockpit_credentials.txt already exists."
fi