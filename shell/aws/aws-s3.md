### 授权
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::backup-hefen"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::backup-hefen/*"
		}
	]
}
```

### 登录
```json
aws configure --profile aws-hefen-s3
```

### 备份
```json
aws s3 cp ./test.txt s3://backup-hefen/ --profile account-b
```
### 下载
```json
aws s3 cp s3://backup-hefen/test.txt . --profile account-b
```

