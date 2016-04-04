#!/usr/bin/python
#####################################################################
## Test Case ID     : TestEngineerAssignment.py
## Module           : TestEngineerAssignment
## Description      : A sample test harness and automated tests for the 'bc' command line tool
## Pre-requisites   : None
## Input Parameters : N/A
## Output Parameters: N/A
## Config Variables : N/A
## Comments         : N/A
## Environment      : N/A
## Author           : Steve Osteen sosteen@gmail.com
######################################################################

import os
import sys
import string
from subprocess import Popen, PIPE


class TestCase(object):
    """Start a Test Case - arg is test case to be run"""

    def __init__(self, name):
        super(TestCase, self).__init__()
        self.tcName = name
        print "%s Test Case" %self.tcName

    def checkBcReady(self):
        """Test if bc is found on the system"""
        if os.system('which -s bc'):
            return False
        else:
            return True

    def runBC(self, command):
        """bc executer pipe for sending and receiving from the command"""
        try:
            if self.checkBcReady():
                bcCommand = Popen("bc", stdin=PIPE, stdout=PIPE, stderr=PIPE)
                bcResult, bcError = bcCommand.communicate("%s\n" %command)
                bcCommand.stdout.close()
                return int(bcResult)
            else:
                print "Execution failed: bc not found"
                exit()
        except OSError as e:
            print >>bcError, "Execution failed: ", e

    def done(self):
        """Test case is done, save, aggregate, and report results"""
        print "------------------------------------------------"

    def subtractTest(self, subtrahend, minuend):
        """Test subtraction"""
        try:
            pyResult = subtrahend - minuend
            bcResult = self.runBC("%s-%s" %(subtrahend, minuend))
            if bcResult == pyResult:
                return "Pass"
            else:
                return "Fail"
        except Exception as e:
            print "Subtract Test execution failed: ", e

    def addTest(self, addenOne, addenTwo):
        """Test Addition"""
        try:
            pyResult = addenOne + addenTwo
            bcResult = self.runBC("%s+%s" %(addenOne, addenTwo))
            if bcResult == pyResult:
                return "Pass"
            else:
                return "Fail"
        except Exception as e:
            print "Add Test failed: ", e

    def multiplyTest(self, multiplier, multiplicand):
        """Test Multiplication"""
        try:
            pyResult = multiplier * multiplicand
            bcResult = self.runBC("%s*%s" %(multiplier, multiplicand))
            if bcResult == pyResult:
                return "Pass"
            else:
                return "Fail"
        except Exception as e:
            print "Multiply Test execution failed: ", e        

    def divideTest(self, dividend, divisor):
        """Test division"""
        try:
            pyResult = dividend / divisor
            bcResult = self.runBC("%s / %s" %(dividend, divisor))
            if bcResult == pyResult:
                return "Pass"
            else:
                return "Fail"
        except ZeroDivisionError as e:
            print "division Test execution failed: ", e  


def header():
    print "Steve Osteen's TestEngineerAssignment"
    print "------------------------------------------------"

def main():
    header()
    TCsub = TestCase("Subtraction")
    if TCsub.subtractTest(2, 2):
        print "Positive Test PASS"
    else:
        print "Positive Test FAIL"
    if TCsub.subtractTest(0, 5):
        print "Zero test PASS"
    else:
        print "Zero test FAIL"
    if TCsub.subtractTest(-5, 1):
        print "Negative test PASS"
    else:
        print "Negative test FAIL"
    TCsub.done()

    TCadd = TestCase("Addition")
    if TCadd.addTest(2, 2):
        print "Positive test PASS"
    else:
        print "Positive test FAIL"
    if TCadd.addTest(0, 5):
        print "Zero test PASS"
    else:
        print "Zero test FAIL"
    if TCadd.addTest(-5, 1):
        print "Negative test PASS"
    else:
        print "Negative test FAIL"
    TCadd.done()

    TCmult = TestCase("Multiplication")
    if TCmult.multiplyTest(2, 2):
        print "Positive test PASS"
    else:
        print "Positive test FAIL"
    if TCmult.multiplyTest(0, 5):
        print "Zero test PASS"
    else:
        print "Zero test FAIL"
    if TCmult.multiplyTest(-5, 1):
        print "Negative test PASS"
    else:
        print "Negative test FAIL"
    TCmult.done()

    TCdiv = TestCase("Division")
    if TCdiv.divideTest(2, 2):
        print "Positive test PASS"
    else:
        print "Positive test FAIL"
    if TCdiv.divideTest(0, 5):
        print "Zero test PASS"
    else:
        print "Zero test FAIL"
    if TCdiv.divideTest(-5, 1):
        print "Negative test PASS"
    else:
        print "Negative test FAIL"
    TCdiv.done()

    #TODO - If I had more time, I would:
    #Run additional tests: large number, float, more comprehensive division tests on div by zero.
    #Actual math sanity check (not rely on python vs bc comparison)
    #Further refactor for even higher level and simpler test case input.
    #Use argv to select the test to run and user selectable test input parameters.
    #Use standard logging instead of prints, output of results to html or other nice format.

if __name__ == "__main__":
    main()