#!/usr/bin/env python3.7
# -*- coding: utf-8 -*-

# libraries
import requests
import threading
import argparse
import warnings

# disable print warnings
warnings.filterwarnings("ignore")

class LoadTest:

    def __init__(self):
        self.usage()

    # config parameters
    def usage(self):
        try:
            self.args = argparse.ArgumentParser()
            self.args.add_argument("-t", help="number of threads", action="store", dest="number_threads", default=5, required=False)
            self.args.add_argument("-r", help="number of requests for threads", action="store", dest="number_requests", default=50, required=False)
            self.args.add_argument("-a", help="application virtualhost", action="store", dest="app_host", required=True)
            self.args.add_argument("-i", help="server ip", action="store", dest="server_ip", required=True)
            self._args = vars(self.args.parse_args())

        except Exception as er:
            print("{} - {}".format(__name__, er))
            exit(1)
    
    @property    
    def server_ip(self):
        return self._args.get('server_ip')
    
    @property    
    def app_host(self):
        return self._args.get('app_host')
    
    @property    
    def number_requests(self):
        return self._args.get('number_requests')
    
    @property    
    def number_threads(self):
        return self._args.get('number_threads')

    def execute_request(self):
        for number in range(int(self.number_requests)):
            try:
                # execute request
                response = requests.get("https://" + self.server_ip, headers={ "Host": self.app_host }, timeout=1, verify=False)
            
            except requests.exceptions.Timeout:
                # break loop
                print("Break with {} requests".format(number))
                break

    def process(self):
        try:
            threads = []
            # create the threads
            for number in range(int(self.number_threads)):
                thread = threading.Thread(target=self.execute_request)
                threads.append(thread)
                # start thread
                thread.start()
                print("Start thread - {}".format(number))        

        except Exception as er:
            print("{} - {}".format(__name__, er))
            exit(1)

def main():
    try:
        # instance class
        load_test = LoadTest()
        load_test.process()
        print("Completed")

    except Exception as er:
        print("{} - {}".format(__name__, er))
        exit(1)

if __name__ == '__main__':
    main()
        