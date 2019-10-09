--Eytzinger Method : binary heap https://opendatastructures.org/ods-java/10_1_BinaryHeap_Implicit_Bi.html
-- left_index(i)  = 2i+1
-- right_index(i) = 2i+2
-- parent_index(i) = (i-1)/2;

package binary_heap is
    pure function left_index(i : integer) return integer;
    pure function right_index(i : integer) return integer;
    pure function parent_index(i : integer) return integer;
end package;
package body binary_heap is


    pure function left_index(i : integer) return integer
    is begin
        return 2*i + 1;
    end;
    pure function right_index(i : integer) return integer
    is begin
        return 2*i + 2;
    end;

    pure function parent_index(i : integer) return integer
    is begin
        return (i-1)/2;
    end;

    -- add(T x) begin
        
    --     memory[write_idx] = x;
    --     int i = write_idx;
    --     int p = parent_index(i);
    --     while (i > 0 and compare(memory[i], memory[p]) < 0) {
    --         swap(i, p);
    --         i := p;
    --         p := parent_index(i);
    --     }

    --     if write_idx + 1 > CAPACITY then full;
    -- end;

end package body;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity binary_heap is
    generic (
        ADDRESS_WIDTH : integer := 4;  -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH : integer := 8
    );
    port (
        reset_n    : in  std_logic;
        clk        : in  std_logic; 
        reset      : in  std_logic; 

        add_en  : in std_logic;
        data_in : in std_logic;
        is_in   : out std_logic;
        add_done : out std_logic;

        search_en : in std_logic;
        search_done : out std_logic;

        remove_en : in std_logic;
        remove_done : out std_logic
    );
end entity;