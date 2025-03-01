import os
import shutil
import robot

output_dir = "reports"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

robot.run(
    "tests/",              
    outputdir=output_dir,
)
