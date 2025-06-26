from email.mime.text import MIMEText
import smtplib
import boto3
import json
import os


GMAIL_SMTP_DOMAIN: str = 'smtp.gmail.com'
GMAIL_SMTP_PORT: int = 587
REGION: str = 'us-east-1'
LOCALSTACK_ENDPOINT = 'http://192.168.2.83:4566'


def handler(event, context):
    # SMTP
    # send_email_via_smtp()

    # SES
    send_email_via_ses()


def send_email_via_smtp():
    sm_client = boto3.client('secretsmanager')
    secret_content = json.loads(
        sm_client.get_secret_value(SecretId=os.environ['SM_SECRET_NAME'])
    )
    sender_email = secret_content['sender_email']
    sender_email_secret = secret_content['sender_email_secret']
    receiver_email = secret_content['receiver_email']

    msg = MIMEText('Hello World!')
    msg['Subject'] =  f'Product has been removed'
    msg['From'] = sender_email_secret
    msg['To'] = receiver_email

    with smtplib.SMTP(GMAIL_SMTP_DOMAIN, GMAIL_SMTP_PORT) as gmail:
        gmail.starttls()
        gmail.login(sender_email, sender_email_secret)
        gmail.sendmail(sender_email, receiver_email, msg.as_string())


def send_email_via_ses():
    ses = boto3.client(
        'ses',
        region_name='us-east-1',
        endpoint_url='https://ses-api.us-east-1.amazonaws.com',
        aws_access_key_id='fake-key',
        aws_secret_access_key='fake-key'
    )
    sm_client = boto3.client('secretsmanager')
    secret_content = json.loads(
        sm_client.get_secret_value(SecretId=os.environ['SM_SECRET_NAME'])
    )
    sender_email = secret_content['sender_email']
    receiver_email = secret_content['receiver_email']

    ses.send_email(
        Source=sender_email,
        Destination={
            'ToAddresses': [receiver_email]
        },
        Message={
            'Subject': {
                'Data': f'Product has been removed'
            },
            'Body': {
                'Text': {
                    'Data': 'Hello World!'
                }
            }
        }
    )
