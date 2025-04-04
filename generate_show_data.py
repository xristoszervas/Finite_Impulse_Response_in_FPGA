import numpy as np
import matplotlib.pyplot as plt

def todecimal(x, bits):
    """Convert signed binary string to signed decimal."""
    assert len(x) <= bits
    n = int(x, 2)
    s = 1 << (bits - 1)
    return (n & (s - 1)) - (n & s)

# Parameters
tap = 8
N1 = 8   # Coefficient bits
N2 = 16  # Input bits
N3 = 32  # Output bits

# Generate test signal
timeVector = np.linspace(0, 2 * np.pi, 100)
output = np.sin(2 * timeVector) + np.cos(3 * timeVector) + 0.3 * np.random.randn(len(timeVector))

# Normalize to fit in 16 bits
max_val = np.max(np.abs(output))
output = output / (max_val * 1.001)  # Ensure margin for rounding

# Convert to 16-bit fixed-point
binary_samples = [np.binary_repr(int(num * (2 ** (N2 - 1))), N2) for num in output]

# Print results
print("Sample# | Binary (16-bit) | Decimal Value")
print("----------------------------------------")
for i, (bin_val, dec_val) in enumerate(zip(binary_samples, output)):
    print(f"{i+1:3d} | {bin_val} | {dec_val:.6f}")

# Plot
plt.figure(figsize=(10, 5))
plt.plot(output, label="Noisy Signal (Normalized)")
plt.title("Original Signal (16-bit Compatible)")
plt.xlabel("Sample")
plt.ylabel("Amplitude")
plt.legend()
plt.grid(True)
plt.show()