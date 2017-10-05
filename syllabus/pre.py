"""
Pre-process a syllabus (class schedule) file. 

"""
import arrow  # Dates and times
import logging

logging.basicConfig(format='%(levelname)s:%(message)s',
                    level=logging.INFO)
log = logging.getLogger(__name__)

base = arrow.now()  # Default, replaced if file has 'begin: ...'
current_time = base  # Use to determine which week need be highlighted
current_week = 0  # Default is 0.


def check_week(beginning, current):
    """
    Check the current time to determine which week need be highlighted.
    Args:
        beginning: a arrow object indicating the start of one week
        current: a arrow object indicating current time(MM/DD/YYYY)
    Return:
        True, if current week is in the week which starts at the beginning date.
        False, otherwise.
    """
    days = (current - beginning).days
    return (0 <= days < 7)


def process(raw):
    """
    Line by line processing of syllabus file.  Each line that needs
    processing is preceded by 'head: ' for some string 'head'.  Lines
    may be continued if they don't contain ':'.  If # is the first
    non-blank character on a line, it is a comment ad skipped. 
    """
    global current_week
    field = None
    entry = {}
    cooked = []

    for line in raw:
        log.debug("Line: {}".format(line))
        line = line.strip()
        if len(line) == 0 or line[0] == "#":
            log.debug("Skipping")
            continue
        parts = line.split(':')
        # print(parts)
        if len(parts) == 1 and field:
            # If length is 1, it means the line here is in a section: topic/project.
            entry[field] = entry[field] + line + " "
            continue
        if len(parts) == 2:
            # If length is 2, it means the line here has some commands
            # which indicate the beginning of section of week, topic and project.
            # Example: ['week', ' 2'],
            #          ['topic', 'something here or blank'],
            #          ['project', 'something here or blank']
            field = parts[0]
            content = parts[1]
        else:
            raise ValueError("Trouble with line: '{}'\n".format(line) +
                             "Split into |{}|".format("|".join(parts)))

        if field == "begin":
            try:
                base = arrow.get(content, "MM/DD/YYYY")
                # print("Base date {}".format(base.isoformat()))
            except:
                raise ValueError("Unable to parse date {}".format(content))

        elif field == "week":
            if entry:
                cooked.append(entry)
                entry = {}
            # Since begins at 09/25, and it is week1.
            # To count next week, plus (count_week - 1) week.
            # Least value of count_week will be 0.
            count_week = int(content) - 1
            beginning_date_week = base.replace(weeks=+count_week)
            entry['topic'] = ""
            entry['project'] = ""
            # Instead of creating a new kind of key for entry, formatting the 'week' may be easier.
            # According to the number of week, plus 7 * (content-1)
            # Example of entry['week']: "1 09/25"
            entry['week'] = content + "\n" + beginning_date_week.format("MM/DD")
            if check_week(beginning_date_week, current_time):
                current_week = int(content)


        elif field == 'topic' or field == 'project':
            entry[field] = content

        else:
            raise ValueError("Syntax error in line: {}".format(line))

    if entry:
        cooked.append(entry)

    return cooked


def main():
    f = open("data/schedule.txt")
    parsed = process(f)
    print(parsed)
    print(current_week) #get current_week


if __name__ == "__main__":
    main()
