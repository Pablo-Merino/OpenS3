# OpenS3

OpenS3 is basically a storage server. What it does is provide a JSON API to
upload and download files to a specified path. It includes a bucket feature to
organize uploads.

Install it now using `gem install opens3`!

### Details!
Uses Thin as HTTP server and rack for interacting with it. For uploading,
listing and downloading files you'll need a token, which is a SHA512 of a string
you choose. You'll also need to set an expiry time for a link when downloading.

### Configuration

The configuration is based on a YAML file:

	---
	dir: ./storage
	port: 8000
	token: TestKey

As you can see, `dir` sets the data directory, `port` sets the port where the
server should listen and `token` sets the string which, after being SHA512'ed,
will be the token.

You can also configure this via command line
	
	opens3 -p 8000 -d ./storage -t SomeToken
	
But using a config file is highly recommended:

	opens3 -c my_config_file.yml

The SHA512 token will be shown on the console on launch.

### API

The API is simple:

##### Basic Upload form and Info
`GET /` for the upload form

`GET /info` for the info form, which only contains the hostname

#### Upload
`POST /upload`: You'll need to set the file to the `file` param, the previously
mentioned token on the `token` param and the `bucket` param for the bucket
(it'll be auto created if it doesn't exists).

#### Download and listing

`GET /list`: You'll need to specify the `token` param with the token and the
`bucket` param with the bucket you'd wish to list

`GET /file`: You'll need to specify a `name` param with the wanted filename, a
`bucket` param with the bucket of the file, a `token` param with the access
token, and a `expire` param with the epoch time (`Time.now.to_i` in Ruby) of
link expiration.

#### Errors
- 100: The path doesn't exists
- 101: The file was not found
- 102: The file already exists (not used since the upload replaces the current file)
- 103: Bucket not found
- 104: Bucket not specified
- 105: The link has expired
- 106: Wrong token
- 107: No file specified on the upload method
- 108: Incorrect method (verb)

#### Responses
All the responses will be on JSON format.
`GET /info` will return something like `{"hostname":"localhost:8000"}` 

`GET /list` will return an array with all the bucket files like
`["avatar.png","twitter_newbird_blue.pdf"]`

`GET /file` will automatically force the file download if all the params are correct

`POST /upload` will return this if the upload was correct
`{"saved":true,"url":"/file?name=twitter_newbird_blue.pdf&bucket=ddd"}`

Any error will be in this format: `{"error":true,"type":error_code}` where
`error_code` will always be an Integer

### Disclaimer

This is in beta stage, it might contain bugs.

### License

OpenS3 - OpenS3 is basically a storage server. What it does is provide a JSON
API to upload and download files to a specified path. It includes a bucket
feature to organize uploads

Copyright (C) 2012 Pablo Merino

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass Ave,
Cambridge, MA 02139, USA.
