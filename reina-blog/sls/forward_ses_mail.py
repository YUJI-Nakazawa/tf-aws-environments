import boto3
import os
import re
from urllib.parse import unquote

ORIGIN_TO  = os.environ.get('ORIGIN_TO')
print(ORIGIN_TO)
FORWARD_TO = os.environ.get('FORWARD_TO')
print(FORWARD_TO)
SES_REGION = os.environ.get('SES_REGION')
S3_BUCKET  = os.environ.get('S3_BUCKET_NAME')

def parse_mail(raw_message):
    replaced_message = re.sub(r"DKIM-Signature: .*(\r|\n|\r\n)(\s+.*(\r|\n|\r\n))*", "", raw_message)
    replaced_message = replaced_message.replace(ORIGIN_TO, FORWARD_TO)
    replaced_message = re.sub("From:.+?\n", "From: %s\r\n" % ORIGIN_TO, replaced_message)
    replaced_message = re.sub("Return-Path:.+?\n", "Return-Path: %s\r\n" % ORIGIN_TO, replaced_message)
    return replaced_message

def send_mail(message):
    ses = boto3.client('ses', region_name=SES_REGION)
    ses.send_raw_email(
        Source = ORIGIN_TO,
        Destinations=[
            FORWARD_TO
        ],
        RawMessage={
            'Data': message
        }
    )

def lambda_handler(event, context):
    print(event)
    try:
        s3_key = unquote(event['Records'][0]['s3']['object']['key'])
        s3 = boto3.client('s3')
        response = s3.get_object(
            Bucket = S3_BUCKET,
            Key    = s3_key
        )
        raw_message = response['Body'].read().decode('utf-8')
        message = parse_mail(raw_message)
        send_mail(message)
    except Exception as e:
        print(e)