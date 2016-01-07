import subprocess

print(subprocess.Popen("perl getLikes.pl 'Bart De Wever'", shell=True, stdout=subprocess.PIPE).stdout.read())