import os
from datetime import datetime
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

try:
    # UPCOMING
    options = Options()
    options.add_argument('--no-sandbox')
    #options.add_argument("--headless=new")
    driver = webdriver.Firefox(options=options)
    driver.get("https://steamdb.info/upcoming/?nosmall")
    bs = BeautifulSoup(driver.page_source, "html.parser")

    body = bs.find("div", {"class": "body-content"})
    releasesContainer = body.find("div", {"class": "container"}, recursive=False)

    releases = []

    # Get first 10 dates
    dates = releasesContainer.find_all("div", {"class": "pre-table-title"})
    releasesIndex = 0

    for date in dates:
        dateText = date.find("a").find_all(string=True, recursive=False)[-1].strip()
        dateObject = datetime.strptime(dateText, '%d %B %Y')
        formattedDate = dateObject.strftime('%d.%m.%Y')
        releases.append({"date": formattedDate, "games": []})
        releasesIndex = releasesIndex + 1
        if releasesIndex >= 20:
            break

    # Assign first 10 game lists to dates
    games = releasesContainer.find_all("div", {"class": "dataTable_table_wrap"})
    releasesIndex = 0

    for game in games:
        appRows = game.find_all("tr", {"class": "app"})
        for app in appRows:
            gameInfo = {}
            name = app.find('a', {"class": "b"}).get_text(strip=True)
            name = (name[:30] + '..') if len(name) > 30 else name
            followers = app.find('td', {"class": "text-center"}).get_text(strip=True)
            gameInfo = {"name": name, "followers": followers}
            releases[releasesIndex]["games"].append(gameInfo)

        # sort games by number of followers
        releases[releasesIndex]["games"] = sorted(releases[releasesIndex]["games"], key=lambda x: int(x['followers'].replace(',', '')), reverse=True)

        releasesIndex = releasesIndex + 1;
        if releasesIndex >= 20:
            break

    releasesIndex = 0
    totalGamesPrinted = 0 # limit to 15 games

    # Print upcoming releases
    steamUpcoming = 'UPCOMING\n'
    for releaseDay in releases:
        # Check if at least one game have more than 1000 followers
        if int(releaseDay['games'][0]['followers'].replace(',', '')) >= 1000:
            steamUpcoming += '${color #B48EAD}' + releaseDay['date'] + '\n'
            for gameRelease in releaseDay['games']:
                followers = int(gameRelease['followers'].replace(',', ''))
                if followers >= 1000:
                    # color games based on followers
                    color = "#BF616A"
                    if (followers >= 20000):
                        color = "#A3BE8C"
                    elif (followers >= 10000):
                        color = "#8FBCBB"
                    elif (followers >= 5000):
                        color = "#EBCB8B"
                    elif (followers >= 3000):
                        color = "#D08770"

                    steamUpcoming += '${color ' + color + '}' + gameRelease['name'] + ' | ' + gameRelease['followers'] + '\n'

                    # limit to 20 printed games
                    totalGamesPrinted = totalGamesPrinted + 1
                    if totalGamesPrinted >= 20:
                        releasesIndex = 10
                        break

        releasesIndex = releasesIndex + 1
        if releasesIndex >= 10:
            break;

    now = datetime.now()
    steamUpcoming += '${color #B48EAD}' + '(' + now.strftime("%d.%m.%Y %H:%M:%S") + ')'

    outputFile = open(os.path.expanduser('~') + '/.config/conky/steam_upcoming.txt', 'w+')
    outputFile.write(steamUpcoming.replace('&', '&amp;'))
    outputFile.close()

finally:
    try:
        driver.quit()
    except:
        pass