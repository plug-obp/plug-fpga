use WORK.explicit_structure.ALL;
package model is
    -- BEGIN ALICE BOB MODEL (state-space)
    --state-space of the lamport alice-bob mutex (unfair to bob)
    constant AB_MODEL : T_EXPLICIT := (
        states => (
            0 => (IDLE,  false,  IDLE,   false),    -- B000000
            1 => (WAITS, true,   IDLE,   false),    -- B011000
            2 => (IDLE,  false,  WAITS,  true),     -- B000011

            3 => (CS,    true,   IDLE,   false),    -- B111000
            4 => (WAITS, true,   WAITS,  true),     -- B011011
            5 => (IDLE,  false,  CS,     true),     -- B000111

            6 => (CS,    true,   WAITS,  true),     -- B111011
            7 => (WAITS, true,   RETRY,  false),    -- B011100
            8 => (WAITS, true,   CS,     true),     -- B011111

            9 => (CS,    true,   RETRY,  false),    -- B111100
           10 => (IDLE,  false,  RETRY,  false)     -- B000100
        ),
        initial => (0 => 0, 1=>2),
        fanout_base => (0, 2, 4, 6, 7, 8, 10, 12, 13, 14, 15, 17),
        fanout => (
            1, 2,   -- fanout( 0)
            3, 4,   -- fanout( 1)
            4, 5,   -- fanout( 2)
            6,      -- fanout( 3)
            7,      -- fanout( 4)
            0, 8,   -- fanout( 5)
            2, 9,   -- fanout( 6)
            9,      -- fanout( 7)
            1,      -- fanout( 8)
            10,     -- fanout( 9)
            5, 7    -- fanout(10)
        )
    );
    -- END ALICE BOB MODEL (state-space)
end package;