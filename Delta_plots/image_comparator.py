import cv2
import numpy as np
import matplotlib.pyplot as plt
from color_maps import *
import os
import re
import time
start_time = time.time()


def read_image(image_path):
    """
    read image to float grid
    :param image_path: path to png of image
    """
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    image = cv2.normalize(image, None, 0, 255, cv2.NORM_MINMAX)
    return image


# todo make masks for both images
def create_masks(image):

    """
    create mask of preserved pixels
    :param image:
    :return: color mask
    """

    # Create a mask where white pixels (approximately [1, 1, 1]) are True
    white_threshold = 0.95 * 255  # Threshold to consider a pixel as white
    mask1 = np.all(image >= white_threshold, axis=-1)

    black_threshold = 0.05 * 255  # Threshold to consider a pixel as black
    mask2 = np.all(image <= black_threshold, axis=-1)

    mask_color = (mask1 | mask2)

    return mask_color


def blur_image(image, gridsize=35, sigma=1):

    if gridsize % 2 == 0:
        gridsize += 1

    blurred_image = cv2.GaussianBlur(image,(gridsize,gridsize),1.5)
    return blurred_image


def subtract_images(master, slave, mask):
    """

    :param master:
    :param slave:
    :param mask:
    :return:
    """

    # Perform the subtraction where the pixels are not white
    diff = cv2.subtract(master, slave)
    diff = blur_image(diff)

    # colormaps
    diff = cv2.normalize(diff, None, 0, 255, cv2.NORM_MINMAX)
    # Convert the normalized image to 8-bit (if it's not already)
    diff = diff + 127.5
    diff = diff.astype(np.uint8)
    # Apply a colormap

    diff = rainbow_haze(diff)

    # For white pixels, retain the original white color
    diff[mask] = 255  # Since white is represented by [1, 1, 1] in normalized space

    return diff


def find_sim_name(path):

    # Define the pattern to match `B` followed by three digits
    pattern = r'\bB\d{3}\b'

    # Find the match
    matches = re.findall(pattern, path)

    if matches:
        result = matches[0]  # Assuming you want the first match
    else:
        result = 'NOT_KNOWN'
    return result


def save_image(image, name, save_path):
    os.chdir(save_path)
    cv2.imwrite(name, image)
    return None


# -----------------------------
master_sim_path = 'D:/UGRacing/UGR EV24/CFD/Scenes/CFD scenes/B027 25mm RH 15ms scenes/X CpT'
slave_sim_path = 'D:/UGRacing/UGR EV24/CFD/Scenes/CFD scenes/B029 25mm RH 15ms Scenes/X CpT'

save_path = 'D:/UGRacing/UGR EV24/CFD/Scenes/CFD scenes/B029 25mm RH 15ms Scenes/DELTA B027/X dCpT'
# ----------------------------

master_sim_name = find_sim_name(master_sim_path)
slave_sim_name = find_sim_name(slave_sim_path)


elements_no = np.minimum(len(os.listdir(master_sim_path)), len(os.listdir(slave_sim_path)))
# todo make so it picks list with less entries

# saving loop

for image_master, image_slave in zip(os.listdir(master_sim_path), os.listdir(slave_sim_path)):

    image_master = os.path.join(master_sim_path, image_master).replace("\\", "/")
    image_slave = os.path.join(slave_sim_path, image_slave).replace("\\", "/")

    print(image_master)
    final_name = (master_sim_name + 'vs' + slave_sim_name + '_' +
                  (os.path.join(master_sim_path, image_master).replace("\\", "/")[-14:]))

    print(final_name)
    master = read_image(image_master)
    slave = read_image(image_slave)

    mask_total = create_masks(master) + create_masks(slave)
    image = subtract_images(master, slave, mask_total)

    save_image(image, final_name, save_path)

print()

end_time = time.time()

# Calculate the elapsed time
elapsed_time = end_time - start_time
print(f'Time taken: {elapsed_time} seconds')
