def parse_log_file(log_filepath):
    """
    Parses a log file and extracts relevant information.

    Args:
        log_filepath (str): The path to the log file.

    Returns:
        list: A list of dictionaries, where each dictionary represents a log entry.
    """
    log_entries = []
    try:
        with open(log_filepath, 'r') as log_file:
            for line in log_file:
                log_entry = parse_log_line(line.strip())
                if log_entry:
                    log_entries.append(log_entry)
    except FileNotFoundError:
        print(f"Error: Log file not found at '{log_filepath}'")
    return log_entries

def parse_log_line(log_line):
    """
    Parses a single line from a log file.

    Args:
        log_line (str): A line from the log file.

    Returns:
        dict: A dictionary representing the parsed log entry, or None if parsing fails.
    """
    parts = log_line.split()
    if len(parts) < 13:
        return None

    timestamp = parts[0]
    Notice = parts[1]
    NoticeType = parts[2]
    NoticeType2 = parts[3]
    CActor = parts[4]
    Killed = parts[5]
    KilledID = parts[6]
    Zone = parts[9]
    Killer = parts[12]

    """
    message = " ".join(parts[2:])
                """
    if parts[3] == "Death>":
        if KilledID.lstrip(KilledID[0]).rstrip(KilledID[-1]) not in Killed:
            print(f"{Killer} killed {Killed} in {Zone} at {timestamp}")
            """
            return {

                #"TIME": timestamp,
                "KILLED": Enemy,
                "KILLER":Killedby,
                "ZONE": Zone,
            
    }"""

if __name__ == "__main__":
    log_filepath = r"C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log"
    parsed_logs = parse_log_file(log_filepath)
    if parsed_logs:
        for entry in parsed_logs:
            print(entry)
