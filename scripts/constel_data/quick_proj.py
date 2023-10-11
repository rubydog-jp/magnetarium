import numpy as np


# モルワイデ図法の変換式
def proj_to_moll(lat, long):
    ra_rad = np.radians(long)
    dec_rad = np.radians(lat)
    alpha = 2. * np.arcsin(np.sqrt(2. / np.pi) * np.sin(dec_rad / 2.))
    x = (2. / np.pi) * (ra_rad * np.cos(dec_rad) /
                        np.sqrt(1. - np.sin(dec_rad / 2.)**2.))
    y = np.sqrt(2. / np.pi) * np.sin(dec_rad / 2.)
    return x, y


# ユニバーサル横メルカトル図法の変換式
def proj_to_merc(lat, long):
    ra_rad = np.radians(long)
    dec_rad = np.radians(lat)
    x = ra_rad
    y = np.log(np.tan(np.pi/4 + dec_rad/2))
    return x, y
