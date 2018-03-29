# Using Ansible to backup archived database tables to an AWS S3 Bucket

This playbook checks for archived RDS MySQL tables on a selected host, backs them up to an AWS S3 bucket, and sends an alert via AWS SNS service (which in turn sends email) once done. It also sends an alert via AWS SNS service if the
script fails at any point during the process. On a successful backup, the **archived tables are deleted from the database server**

## Requirements:
On host:
* pip
* MySQL-python
* boto3

On local:
* boto

## Configuration:
Open the `vars.yml` file and put in the correct information for:

**Host**
* `ssh_user` - ssh user for host

**Database**
* `mysql_user`
* `mysql_password`
* `mysql_db`
* `archive_prefix` - prefix of archived tables. Already set to ARCHIVE_

**AWS**
* `aws_access_key`
* `aws_secret_key`
* `bucket_name`
* `notification_email` - where do you want notifications emails to be sent
* `sns_topic` - this is the Topic ARN wihch looks something like arn:aws:sns:us-east-1:444455556666:MyTopic
* `region` - ie your AWS SNS region

Open the `hosts` file and replace `example.com` with your your database server host.

Now you are ready to initiate the backups on your S3 bucket. Go ahead and run this command:

```
ansible-playbook -i hosts archiver.yml
```
