## YouTube Playlist creation tool


## Usage

Copy your `client_secrets.json` from Google API (https://cloud.google.com/console) in the project directory.

Edit the file to change the following constant parameters:

* Video list (will be reversed in playlist)
* Playlist Title
* Playlist Description

```
gem install 'google-api-client'
```

or, if you use Bundler:

```
bundle install
```

then create your playlist:

```
ruby playlist_api_client.rb
```
