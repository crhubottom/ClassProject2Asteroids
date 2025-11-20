package org.psnbtech.util;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ClockTest {
    Clock c = new Clock(10);

    @Test
    void setCyclesPerSecond() {
        c.setCyclesPerSecond(20);
        assertEquals(530.0f, c.millisPerCycle);
    }
    @Test
    void isPaused() {
        c.setPaused(true);
        assertTrue(c.isPaused());
    }


}