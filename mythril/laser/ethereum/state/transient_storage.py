"""This module contains a representation of a smart contract's transient storage."""
import logging
from copy import deepcopy
from typing import Any, Dict


from mythril.laser.smt import BitVec, simplify, If, Bool

log = logging.getLogger(__name__)


class TransientStorage:
    """A class representing contract transient storage"""

    def __init__(self) -> None:
        """Constructor for transient storage."""
        
        self._transientStorage: Dict[BitVec, BitVec] = {}

    def __getitem__(self, item: BitVec) -> BitVec:
        """
        Access a word from a specified transient storage index.

        :param index: integer representing the word index to access
        :return: 256-bit word at the specified index
        """

        transientStorage = self._transientStorage
        try:
            return simplify(transientStorage[item])
        except KeyError:
            # if index uninitialized
            return 0;

    def __setitem__(self, key, value: Any) -> None:
        if isinstance(value, Bool):
            value = If(value, 1, 0)

        self._transientStorage[key] = value

    def __deepcopy__(self, memodict=dict()):
        transientStorage = TransientStorage()
        """deepcopy (like storage) instead of copy like for memory, see how tests perform"""
        transientStorage._transientStorage = deepcopy(self._transientStorage)
        return transientStorage

    def __str__(self) -> str:
        # TODO: Do something better here
        return str(self._transientStorage)