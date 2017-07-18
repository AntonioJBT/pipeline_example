#!/usr/bin/python
job_queue_name    = "med-bio"
#job_other_options = "-P YOUR_PROJECT_NAME_GOES_HERE"

from ruffus import *
from ruffus.drmaa_wrapper import run_job, error_drmaa_job

parser = cmdline.get_argparse(description='WHAT DOES THIS PIPELINE DO?')

options = parser.parse_args()

#  logger which can be passed to multiprocessing ruffus tasks
logger, logger_mutex = cmdline.setup_logging (__name__, options.log_file, options.verbose)


#
#   start shared drmaa session for all jobs / tasks in pipeline
#
import drmaa
drmaa_session = drmaa.Session()
drmaa_session.initialize()

@originate(["1.chromosome", "X.chromosome"],
           logger, logger_mutex)
def create_test_files(output_file):
    try:
        stdout_res, stderr_res = "",""
        job_queue_name, job_other_options = get_queue_options()

        #
        #   ruffus.drmaa_wrapper.run_job
        #
        stdout_res, stderr_res  = run_job(cmd_str           = "touch " + output_file,
                                          job_name          = job_name,
                                          logger            = logger,
                                          drmaa_session     = drmaa_session,
                                          run_locally       = options.local_run,
                                          job_queue_name    = job_queue_name,
                                          job_other_options = job_other_options)

    # relay all the stdout, stderr, drmaa output to diagnose failures
    except error_drmaa_job as err:
        raise Exception("\n".join(map(str,
                            "Failed to run:", 
                            cmd, err, stdout_res, stderr_res)))


if __name__ == '__main__':
    cmdline.run (options, multithread = options.jobs)
    # cleanup drmaa
    drmaa_session.exit()
