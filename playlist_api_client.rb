require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

VIDEOS = [
  'H4znsXCH_2Y',
  'ZmeudwRMrsU',
  '3rtTsryIi3w',
  'xhowIMBsrCU',
  'wLisaEMZsag',
  'MhH_ucrPMZc',
  'cchjirF7zM4',
  'L6ddlZ1BxIo',
  '8MqoTIteXDs',
  '0Yi3dLek4SI',
  'jcIOg_m-bp4',
  'EMp4DS64zTE',
  '4VWo1LSly_k',
  'zynxSanDBzg',
].reverse

PLAYLIST_TITLE = 'J-Top #258 - 27/10/2013'
PLAYLIST_DESCRIPTION = 'Votez pour le J-Top chaque semaine sur http://nolife-tv.com'

# Initialize the client.
client = Google::APIClient.new(
  :application_name => 'YouTube Playlist Generator',
  :application_version => '1.0.0'
)

# Initialize Google+ API. Note this will make a request to the
# discovery service every time, so be sure to use serialization
# in your production code. Check the samples for more details.
youtube = client.discovered_api('youtube', 'v3')

# Load client secrets from your client_secrets.json.
client_secrets = Google::APIClient::ClientSecrets.load

# Run installed application flow. Check the samples for a more
# complete example that saves the credentials between runs.
flow = Google::APIClient::InstalledAppFlow.new(
  :client_id => client_secrets.client_id,
  :client_secret => client_secrets.client_secret,
  :scope => ['https://www.googleapis.com/auth/youtube']
)
client.authorization = flow.authorize

result = client.execute!(
  api_method: youtube.playlists.insert,
  parameters: {
    part: 'snippet,status',
  },
  body_object: {
    snippet: {
      title: PLAYLIST_TITLE, 
      description: PLAYLIST_DESCRIPTION,
      status: {'private_status' => 'private'}
    },
  },
)

puts "Created playlist id #{result.data.id}"

playlist_id = result.data.id

VIDEOS.each do |video_id|
  result = client.execute!(
    api_method: youtube.playlist_items.insert,
    parameters: {part: 'snippet,contentDetails,status'},
    body_object: {
      snippet: {
        playlistId: playlist_id,
        resourceId: {kind: 'youtube#video', videoId: video_id}
      }
    }
  )
  puts "Inserted video #{result.data.snippet.title} (id: #{result.data.id})"
  sleep(0.1) # Mitigate race condition on YouTube side
end