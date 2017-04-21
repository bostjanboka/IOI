import subprocess
import sys


print(str(sys.argv[1]))
print(str(sys.argv[2])+"/out1")

p = subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/candy.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out1"], stdout=subprocess.PIPE)

nmap_lines = p.stdout.splitlines()
print(nmap_lines)

subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/feathers.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out2"], stdout=subprocess.PIPE)

subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/la_muse.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out3"], stdout=subprocess.PIPE)

subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/mosaic.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out4"], stdout=subprocess.PIPE)

subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/the_scream.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out5"], stdout=subprocess.PIPE)

subprocess.run(["th", "fast_neural_style.lua", "-model", "models/instance_norm/udnie.t7", "-input_dir", str(sys.argv[1]), "-output_dir", str(sys.argv[2])+"out6"], stdout=subprocess.PIPE)



#call(["th", "/home/boka/fast-neural-style/fast_neural_style.lua", "-model", "/home/boka/fast-neural-style/models/instance_norm/udnie.t7", "-input_dir", "/home/boka/ioi/processingDir/image", "-output_dir", "/home/boka/ioi/processingDir/out"])


#th /home/boka/fast-neural-style/fast_neural_style.lua -model /home/boka/fast-neural-style/models/instance_norm/udnie.t7 -input_dir /home/boka/ioi/processingDir/image -output_dir /home/boka/ioi/processingDir/out
