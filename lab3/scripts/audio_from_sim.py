"""
This script converts a raw square wave signal from a Verilog simulation into a .wav audio file for playback.

Usage: python3 scripts/audio_from_sim.py sim/build/output.txt

This script will generate a file named output.wav that can be played using the 'play binary'
Playback: play output.wav
"""

import wave
import random
import struct
import sys

values = []

filepath = sys.argv[1]
with open(filepath, 'r') as samples_file:
    data = samples_file.read()

for note in data:
    value = 0
    if (note == '0'):
        value = -20000
    elif (note == '1'):
        value = 20000
    else:
        continue
    packed_value = struct.pack('<hh', value, value) # Pack both L and R channel into 2 bytes
    values.append(packed_value)
print(values)

output_wav = wave.open('output.wav', 'w')
output_wav.setparams((2, 2, 44100, 0, 'NONE', 'not compressed'))
output_wav.writeframes(b''.join(values))
output_wav.close()
sys.exit(0)
