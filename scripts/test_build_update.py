# [!] run this from the map_storage root folder

"""
Not sure whether I'll need any python for build-update aside from perhaps
invoking the saxon Transformation
want to try to store existing implementation info in a var and then add to
new output from updated sources, which I don't think would require the sort
of thing I started to attempt below
"""

from sys import argv
import shutil
# https://docs.python.org/3.6/library/shutil.html
import os

# get needed filenames
script, storage_filepath = argv

# create copy of storage instance for processing
shutil.copy2(f"{storage_filepath}", "storage_for_processing.xml")

# process the copy, stylesheet saves result as original file name
os.system("java -cp ~/ries/saxon/saxon-he-10.3.jar net.sf.saxon.Transform -t -s:storage_for_processing.xml -xsl:scripts/build_update_storage.xsl")

"""
Following gives a syntax error:

>   File "scripts/build_update.py", line 18
>     if os.path.exists("storage_for_processing.xml")
>                                             ^
>   SyntaxError: invalid syntax

Best guess is that process_existing is still being processed??
See https://docs.python.org/3.6/library/os.html#os.remove
    "On Windows, attempting to remove a file that is in use causes an exception to be raised"

# clean up
if os.path.exists("process_existing.xml")
    os.remove("process_existing.xml")
else print("Something's wrong with your files again!")
"""
