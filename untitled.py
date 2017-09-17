#!/usr/bin/python

from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.tools import argparser
import sys
import urllib.request



# Set DEVELOPER_KEY to the API key value from the APIs & auth > Registered apps
# tab of
#   https://cloud.google.com/console
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = "AIzaSyB8lEIhwplGmwF3whOli03DcsnDM04_fMs"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

def youtube_search(options):
  youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION,
    developerKey=DEVELOPER_KEY)

  # Call the search.list method to retrieve results matching the specified
  # query term.
  search_response = youtube.search().list(
    q=options.q,
    part="id,snippet",
    maxResults=options.max_results,
    type=options.type,
    videoDuration=options.duration,
    relevanceLanguage=options.language
  ).execute()

  videos = []
  channels = []
  playlists = []

  # Add each result to the appropriate list, and then display the lists of
  # matching videos, channels, and playlists.
  for search_result in search_response.get("items", []):
    if search_result["id"]["kind"] == "youtube#video":
      videos.append("%s,%s" %(search_result["id"]["videoId"],search_result["snippet"]["title"]))
    elif search_result["id"]["kind"] == "youtube#channel":
      channels.append("%s (%s)" % (search_result["snippet"]["title"],
                                   search_result["id"]["channelId"]))
    elif search_result["id"]["kind"] == "youtube#playlist":
      playlists.append("%s (%s)" % (search_result["snippet"]["title"],
                                    search_result["id"]["playlistId"]))

  def videos_list_by_id(service, **kwargs):
    # kwargs = remove_empty_kwargs(**kwargs) # See full sample for function
    results = service.videos().list(
      **kwargs
    ).execute()
    return results
    # print(results)

  for vid in videos:
    details = videos_list_by_id(youtube,
      part='snippet,contentDetails',
    id=vid)
    time = details["items"][0]["contentDetails"]["duration"].split("T")[1].split("M")[0]
    link="https://www.youtube.com/watch?v=%s"%vid
    print (link + "," + time)
  # return link + "," +  time
  # print ("Channels:\n", "\n".join(channels), "\n")
  # print ("Playlists:\n", "\n".join(playlists), "\n")


if __name__ == "__main__":
  argparser.add_argument("--q", help="Search term", default="Machine Learning")

  argparser.add_argument("--max-results", help="Max results", default=3)
  argparser.add_argument("--type", help="type", default="video")



  argparser.add_argument("--duration", help="video duration", default="medium")
  argparser.add_argument("--language", help="language", default="en")

  args = argparser.parse_args()

  #try:
  youtube_search(args)
  #except HttpError, e:
   # print ("An HTTP error %d occurred:\n%s" % (e.resp.status, e.content)
#search.py
