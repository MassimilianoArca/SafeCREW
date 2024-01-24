import unicodedata


def normalize_string(s):
    return unicodedata.normalize("NFKD", s)