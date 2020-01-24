%python 
from sirca_announcement import SearchTool, SortOrder
ann = SearchTool(globals())
results = ann.search(            
    startDate='2006-01-01',
    endDate='2017-12-31',
#   startTime='13:00:00',
#   endTime='16:00:00',
#   header='+option?', # Text search on title/header of announcement; can use AND, OR, NOT for multiple conditions. + means includes and - means excludes. 
#   content='option OR performance OR retention OR incentive OR employee OR consultant OR director OR contractor OR manager', # Text search on pdf content; can use AND, OR, NOT for multiple conditions (e.g. notice AND ceasing)
#   types=['6013'],  # Search for Primary Report Code. Multiple allowed, passed in as list, e.g. ['1000', '2000']. 
    subtypes=['6013'], # Search for Sub Report Code. Multiple subtypes allowed, passed in as list, e.g. ['01001','02001']. The report code for the Appendix 3B is [6013].
#   past='3year',      # Search going back 3 years.
    asxCodes=['ADN'], # More company symbols can be added inside the square brackets separated by commas, e.g. ['CBA', 'BHP']
#   limit=50,        # Displaying only the first 100 records, max limit is 1000 at a time.
#   offset=0,         # If there more results, use offset to get the next batch of data. Refer to 6.1 to understand how to use this function 
    sort=SortOrder.DATE_ASC)
results.downloadAll() # Downloads the results to a zip file
