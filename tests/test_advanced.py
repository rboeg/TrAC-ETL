# -*- coding: utf-8 -*-

from .context import trac_etl

import unittest


class AdvancedTestSuite(unittest.TestCase):
    """Advanced test cases."""

    def test_thoughts(self):
        self.assertIsNone(trac_etl.hmm())


if __name__ == '__main__':
    unittest.main()
