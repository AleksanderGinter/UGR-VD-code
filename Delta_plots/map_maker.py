import numpy as np
import matplotlib.pyplot as plt

# go to mapmaking tool https://eltos.github.io/gradient/#4C71FF-1FB300-000000-C7030D-FC4A53
# create a map and copy the "Matplotlib" window
# paste the table in the color points variable and remove 2 last closing brackets
# copy the core result into the color_map.py file following the examples already in there


# Given list of positions with corresponding RGB colors in the range [0, 1]
color_points = [
    (0.000, (0.035, 0.176, 0.694)),
    (0.200, (0.008, 0.392, 0.012)),
    (0.500, (0.694, 0.694, 0.694)),
    (0.800, (0.678, 0.522, 0.000)),
    (1.000, (0.651, 0.000, 0.071))
]

# Convert RGB from [0, 1] to [0, 255]
color_points_255 = [(pos, tuple(int(val * 255) for val in rgb)) for pos, rgb in color_points]

# Extract positions and colors separately for interpolation
positions = [pos for pos, _ in color_points_255]
colors = np.array([rgb for _, rgb in color_points_255])

# Interpolate linearly between positions to generate more colors
n_points = 256  # Number of points to interpolate
new_positions = np.linspace(0, 1, n_points)

# Perform interpolation for each RGB channel
r_interp = np.interp(new_positions, positions, colors[:, 0])
g_interp = np.interp(new_positions, positions, colors[:, 1])
b_interp = np.interp(new_positions, positions, colors[:, 2])


# Combine interpolated channels into RGB values
interpolated_colors = np.stack([r_interp, g_interp, b_interp], axis=-1).astype(np.uint8)

# Print RGB values and their corresponding positions
print("Position\tR\tG\tB")
red = []
green = []
blue = []
for pos, (r, g, b) in zip(new_positions, interpolated_colors):
    red.append(r)
    green.append(g)
    blue.append(b)

print(red)
print(green)
print(blue)

# Plot the color map to visualize the interpolation
plt.imshow([interpolated_colors], aspect='auto')
plt.axis('off')
plt.show()

