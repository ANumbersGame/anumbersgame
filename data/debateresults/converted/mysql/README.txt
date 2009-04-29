The files named NNNN.mysql are MySQL-friendly database dumps of the data available at http://commweb.fullerton.edu/jbruschke/web/ResultsArchives/archiveindex.aspx .
They were extracted with mdbtools and the script in the data/scripts directory.
These files have every "Div" replaced with "Diiv", since MySQL doesn't like "Div" as a column name and mdbtools doesn't know that. The replacement is global, so some spelling may be broken in the judge philosophies and some names may be incorrect.

create.mysql creates databases in a MySQL instance to work with these files, granting all privileges to the user with the empty name.

import.sh imports the dumps and creates a new ballots table

ballots.mysql describes the structure of the ballots table. The MasterResults table that debateresults.com uses makes it hard to poll judges' decisions without a massive UNION ALL, so we do it once and for all to make later queries easier.
