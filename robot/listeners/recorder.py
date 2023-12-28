import subprocess as sub
import platform
import re
import os
import time
from pathlib import Path


class recorder:
    ROBOT_LISTENER_API_VERSION = 2
    def __init__(self, test_recording='split', recordable=None,
                 start_script_path='listeners/start_recording.sh'):
        """
        Handle provided parameters and set class variables.
        Examples
        --------
        robot --listener listeners/Recorder.py test.robot (Use Defaults)
        robot --listener listeners/Recorder.py:off test.robot (Recording off)
        robot --listener listeners/Recorder.py:pass:smoke,foo test.robot
             - Passed tests with tag smoke or foo in it
        robot --listener listeners/Recorder.py:pass:smoke,foo:path/to/my_run.sh test.robot
             - Passed tests with tag smoke or foo in it. Executable path is path/to/my_run.sh
        Parameters:
        -----------
        :param test_recording: Recording on/off/pass/fail
            - On = Record all tests. (default)
            - Off = Recording is off
            - Pass = Record all, but save passed cases only
            - Fail = Record all, but save failed cases only
        :param recordable: Record only tests with certain tag.
        :param start_script_path: Path to shell script which will start the recording.
            - Default: project_root/scripts/run_video_linux.sh
        """
        self.test_recording = test_recording.lower()
        self.start = start_script_path
        self.recordable = self.get_tags_list(recordable)
        self.os = platform.system()
        self.process_ongoing = False
        self.process = None
        self.filename = None
        self.set_recordings_folder()


    def start_suite(self, name, attrs):
        """
        Log basic information regarding ongoing session.
        """
        if self.test_recording.lower() != 'off':
            print('Starting test suite. Recording listener is in active state.')
            print('Operating system: {}'.format(self.os))
            print('Start recording:')


    def start_test(self, name, attrs):
        """
        Check if current test is meant to be recorded based on given parameters
        (test_recording on, or matching tag). Test case
        name will be used as a filename for a video recording. Special characters
        will be replaced (_).
        """
        if self.test_recording.lower() != 'off':
            self.filename = re.sub('[^a-zA-Z0-9]', '_', name)
            tags = attrs.get('tags')
            if not self.recordable:
                self.start_recording(self.filename)
            elif self.recordable and any(item in self.recordable for item in tags):
                self.start_recording(self.filename)
            if self.process_ongoing:
                print('Recording started for test {}. Time: {}'.format(name, attrs.get('starttime')))


    def end_test(self, name, attrs):
        """If there is ongoing recording, stop it before next test"""
        test_result = attrs.get('status').lower()
        if self.test_recording != 'off':
            self.stop_recording()
            if not self.process_ongoing:
                print('Recording done for test {}. Time: {}'.format(name, attrs.get('endtime')))
                if self.test_recording == 'pass' or self.test_recording == 'fail':
                    if self.test_recording != test_result:
                        self.remove_recording(self.filename)


    def start_recording(self, filename):
        """ Start recording."""
        print(self.os.lower())
        print('{}'.format(filename))
        self.process = sub.call(['sh', './listeners/start_recording.sh', f'{filename}'])
        print('Got from shell {}'.format(self.process))
        print(self.process)
        self.process_ongoing = True


    def stop_recording(self):
        """ Stop recording"""
        if self.process_ongoing:
            sub.call(['sh', './listeners/stop_recording.sh'])
        self.process_ongoing = False


    @staticmethod
    def get_tags_list(recordable):
        """ Return tags to be recorded as a list if defined"""
        if recordable:
            return list(recordable.split(','))
        return None


    @staticmethod
    def remove_recording(filename):
        filepath = Path('pipeline_videos/{}.webm'.format(filename))
        if Path(filepath).exists():
            os.remove(filepath)


    @staticmethod
    def set_recordings_folder():
        # Check if target folder already created in previous runs.
        print('Path already exists? {}'.format(Path('pipeline_videos').exists()))
        if Path('pipeline_videos').exists():
            # Remove old videos
            os.rmdir('pipeline_videos')
            print('Found existing pipeline_videos folder. Removing it..')
        os.mkdir('pipeline_videos')