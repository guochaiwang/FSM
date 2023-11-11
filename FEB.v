
-- dec224

library ieee;
use ieee.std_logic_1164.all;
entity dec224 is
port(x: in std_logic_vector( 1 downto 0);
     y: out std_logic_vector(3 downto 0));
end dec224;

architecture behave of dec224 is

begin
with x(1 downto 0) select 
  y(3 downto 0)<="0001" when "00",   --ram
                 "0010" when "01",    --r0
					  "0100" when "10",    --r1
					  "1000" when "11",    --r2
					  "0000" when others;
end behave;

--reg

library ieee;
use ieee.std_logic_1164.all;
entity reg is
port(reset,clk,en:in std_logic;
     D: in std_logic_vector(8 downto 0);
	  Q: out std_logic_vector(8 downto 0));
end reg;

architecture behave of reg is

begin
process(reset,clk,en)
begin
 if reset='0' then Q <="000000000";
 elsif rising_edge(clk) then
    if en='1' then Q<=D;
	 end if;
 end if;
end process;

end behave;

--mux8

library ieee;
use ieee.std_logic_1164.all;

entity mux8 is
port(X0,X1,X2,X3,X4,X5,X6,X7: in std_logic_vector(8 downto 0);
     sel: in std_logic_vector(2 downto 0);
	  Y: out std_logic_vector(8 downto 0));
end mux8;

architecture behave of mux8 is
begin
with sel(2 downto 0) select
        Y(8 downto 0)<= X0 when "000",
								X1 when "001",
								X2 when "010",
								X3 when "011",
								X4 when "100",
								X5 when "101",
								X6 when "110",
								X7 when "111",
								X0 when others;
end behave;
				

--adder and subtractor

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub is
port(A: in std_logic;
    Q1,Q2: in std_logic_vector(8 downto 0);
    s: out std_logic_vector(8 downto 0));
end addsub;	

architecture behave of addsub is

begin

s(8 downto 0) <= std_logic_vector(signed(Q1)+signed(Q2)) when A='0'
else std_logic_vector(signed(Q1)-signed(Q2));

end behave;


--FSM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FSM is
port(clk,reset,CS: in std_logic;
     pcin: in std_logic_vector(16 downto 0);
     v: out std_logic_vector(5 downto 0);
	  addr: out std_logic_vector(8 downto 0);
	  pcout: out std_logic_vector(7 downto 0));
end FSM;

architecture behave of FSM is

signal bc: std_logic_vector(1 downto 0);
signal pc0,nextpc: std_logic_vector(7 downto 0);
signal add0: std_logic_vector(8 downto 0);

begin

process(clk,reset)
begin if reset ='0' then 	pcout<="00000000"; pc0<="00000000";
    elsif rising_edge(clk) then pcout<= nextpc;pc0<=nextpc;
	 end if;
end process;

v(5 downto 0)<= pcin(16 downto 11);
bc(1 downto 0)<= pcin(10 downto 9);
add0( 8 downto 0) <= pcin(8 downto 0);


nextpc<= std_logic_vector(unsigned(pc0)+1) when bc ="00"    --branch control is 00
    else add0(7 downto 0)                   when bc ="01"    
	 else std_logic_vector(unsigned(pc0)+1) when (bc="10" and CS='1')  --negtive
	 else add0 (7 downto 0)                  when (bc="10" and CS='0')   --positive
	 else std_logic_vector(unsigned(pc0)+1) when (bc="11" and CS='0')  --possitive
	 else add0(7 downto 0)                 when (bc="11" and CS='1')   --negtive
	 else "00000000";
	 
addr(8 downto 0) <= "100000001" when pcin(16 downto 11)="000110"else  --S2 R3=n
                    "000000001" when pcin(16 downto 11)="100000"else   --S4 ram=R1+R2
						  "000000001" when pcin(16 downto 11)="000100"else   --S6 R2=RAM
						  "100000001" when pcin(16 downto 11)="001000"else    --S8 output=r2
						  "000000000";


end behave;


--1hz counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity counter is
port(Reset,Clkin: in std_logic;
     Clkout: out std_logic);
end counter;

architecture numeric of counter is
constant zero: unsigned:="00000000000000000000000000";
signal U:unsigned(25 downto 0);
begin
process(Clkin,Reset)
begin
   if Reset = '0' then U<=zero;    --cannot write U<=0
	   elsif rising_edge(Clkin)then
		  if(U=25000000)then
		  Clkout<='0';
		  elsif(U=50000000) then U<=zero; Clkout<='1';
		  end if;
		  U <= U+1;
	end if;
end process;
end numeric;


--flag
library ieee;
use ieee.std_logic_1164.all;
entity flag is
port(D:in std_logic_vector(8 downto 0);
     CS: out std_logic);
end flag;

architecture behave of flag is

begin
CS<='1' when D(8)='1' else '0';
end behave;

--ROM
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
port( PC: in std_logic_vector(7 downto 0);
      Q: out std_logic_vector(16 downto 0));
end ROM;

architecture behave of ROM is
type ROM is array(natural range <>) of std_logic_vector(16 downto 0);
constant progMem : ROM :=
("11001000000000000",    --S0  r1=0
 "11110000000000000",    --S1   r2=1
 "00011000100000001",    --S2    r3=n
 "10111011000001000",    --S3    r3=r3-1 if negtive then go to S8 else S4
 "10000000000000001",    --S4    RAM=R1+R2
 "01001000000000000",    --S5    R1=R2
 "00010000000000001",     --S6   R2=RAM
 "10111010000000100",     --S7   R3=R3-1  if positive go back to S4 else S8
 "00100000100000001",     --S8    OUTput=R1
 "00101001000001001");     --S9    R1=R1   loop in S9

begin
 Q<= progMem(to_integer(unsigned(PC)));
 end behave;
 
 --RAM/IO
 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ramio is
port(clk,enable: in std_logic;
     data,input,address: in std_logic_vector(8 downto 0);
   q,output: out std_logic_vector(8 downto 0));
  end ramio;


architecture logicfunction of ramio is
type RAM is array(0 to 127) of std_logic_vector(8 downto 0);
signal datamemory : RAM; 
begin 

q<= datamemory(to_integer(unsigned(address))) when address(8) ='0' else input;  
 
  process(clk,enable)
    variable RAMaddress:unsigned(8 downto 0);
	 begin
	  if rising_edge(clk)then
	    RAMaddress := unsigned(address);
		 if(enable='1') then
		   if(address(8)='0') then datamemory(to_integer(RAMaddress))<=data; 
			   else output<= data;
			end if;
		end if;
		end if;
end process;

end logicfunction;

--DCR

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DCR is
port(x: in std_logic_vector(8 downto 0);
     y: out std_logic_vector(8 downto 0));
end DCR;

architecture behave of DCR is

begin

y<=std_logic_vector(signed(x)-1);

end behave;


--7-seg decoder

library ieee;
use ieee.std_logic_1164.all;
entity Hex2SSD is
port(HX:in std_logic_vector(3 downto 0);
      SSD: out std_logic_vector(6 downto 0));
	end Hex2SSD;
architecture RTL of Hex2SSD is
begin
  with HX select
     SSD <= "1000000" when "0000",
	         "1111001" when "0001", "0100100" when "0010",
				"0110000" when "0011", "0011001" when "0100",
				"0010010" when "0101", "0000010" when "0110",
				"1111000" when "0111", "0000000" when "1000",
				"0010000" when "1001", "0010000" when "1010",
				"0000011" when "1011", "1000110" when "1100",
				"0100001" when "1101", "0000110" when "1110",
				"0001110" when "1111", "0111111" when others;
end RTL;



--bcd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bcd is
port(x:in std_logic_vector(8 downto 0);
	  y1,y2,y3: out std_logic_vector(3 downto 0));
end bcd;

architecture behave of bcd is
signal d,d1,d2:integer range 0 to 999;

type bcd is array(natural range <>) of std_logic_vector(3 downto 0);
constant progMem : bcd :=
("0000",   --0
 "0001",    --1
 "0010",    --2
 "0011",    --3
 "0100",    --4
 "0101",    --5
 "0110",     --6
 "0111",    --7
 "1000",     --8
 "1001");     --9
				
begin
		d<=to_integer(unsigned(x));
		d1<=d/10;
		d2<=d1/10;
		y1<=progMem(d rem 10);
		y2<=progMem(d1 rem 10);
		y3<=progMem(d2 rem 10);

end behave;
		

--feb


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity feb is
port(clk0,reset0: in std_logic;
     input: in std_logic_vector(8 downto 0);
   output: out std_logic_vector(20 downto 0);
	light: out std_logic);
  end feb;
  
 architecture structrual of feb is
 
 component dec224 
 port(x: in std_logic_vector( 1 downto 0);y: out std_logic_vector(3 downto 0));
 end component;
 
 component reg
 port(reset,clk,en:in std_logic;D: in std_logic_vector(8 downto 0);Q: out std_logic_vector(8 downto 0));
end component;

component mux8
port(X0,X1,X2,X3,X4,X5,X6,X7: in std_logic_vector(8 downto 0);sel: in std_logic_vector(2 downto 0);Y: out std_logic_vector(8 downto 0));
end component;

component addsub
port(A: in std_logic;Q1,Q2: in std_logic_vector(8 downto 0);s: out std_logic_vector(8 downto 0));
end component;

component FSM
port(clk,reset,CS: in std_logic;pcin: in std_logic_vector(16 downto 0);v: out std_logic_vector(5 downto 0);pcout: out std_logic_vector(7 downto 0);addr: out std_logic_vector(8 downto 0));
end component;

component counter
port(Reset,Clkin: in std_logic;Clkout: out std_logic);
end component;

component flag
port(D:in std_logic_vector(8 downto 0);CS: out std_logic);
end component;

component ROM
port( PC: in std_logic_vector(7 downto 0); Q: out std_logic_vector(16 downto 0));
end component;

component ramio
port(clk,enable: in std_logic;input: in std_logic_vector(8 downto 0);data,address:in std_logic_vector(8 downto 0);q,output: out std_logic_vector(8 downto 0));
end component;

component DCR
port(x: in std_logic_vector(8 downto 0);y: out std_logic_vector(8 downto 0));
end component;

component Hex2SSD
port(HX:in std_logic_vector(3 downto 0);SSD: out std_logic_vector(6 downto 0));
end component;

component bcd
port(x:in std_logic_vector(8 downto 0);y1,y2,y3: out std_logic_vector(3 downto 0));
end component;


signal CS: std_logic;
signal en: std_logic_vector(3 downto 0);
signal pc: std_logic_vector(7 downto 0);
signal Q0,Q1,Q2,Q3,D,sum0,sum1,X6,X7,digout,address0: std_logic_vector(8 downto 0);
signal rom0: std_logic_vector(16 downto 0);
signal v: std_logic_vector(5 downto 0);
signal clk1: std_logic;
signal d1,d2,d3: std_logic_vector(3 downto 0);



begin

X6(8 downto 0)<="000000000";
X7(8 downto 0)<="000000001";
light<= reset0;

instan0: ROM port map(PC=>pc, Q=>rom0);
instan1: ramio port map(clk=>clk0,enable=>en(0),data=>D,input=>input(8 downto 0),address=>address0(8 downto 0),q=>Q0,output=>digout(8 downto 0));
instan2: reg   port map(reset=>reset0, clk=>clk0, en=>en(1), D=>D,Q=>Q1);
instan3: reg   port map(reset=>reset0, clk=>clk0, en=>en(2), D=>D,Q=>Q2);
instan4: reg   port map(reset=>reset0, clk=>clk0, en=>en(3), D=>D,Q=>Q3);
instan5: dec224 port map(x=>v(2 downto 1), y=>en(3 downto 0));
instan6: mux8 port map(X0=>Q0,X1=>Q1,X2=>Q2,X3=>Q3,X4=>sum0,X5=>sum1,X6=>X6,X7=>X7,sel=>v(5 downto 3),Y=>D);
instan7: addsub port map(A=>v(0),Q1=>Q1,Q2=>Q2,s=>sum0);
instan8: flag port map(D=>D,CS=>CS);
instan9: DCR port map(x=>Q3, y=>sum1);
instan10: FSM port map(clk=>clk0,reset=>reset0,CS=>CS,pcin=>rom0(16 downto 0),v=>v(5 downto 0),pcout=>pc(7 downto 0),addr=>address0(8 downto 0));
instan11: Hex2SSD port map(HX=>d1, SSD=>output(6 downto 0));
instan12: Hex2SSD port map(HX=>d2, SSD=>output(13 downto 7));
instan13: Hex2SSD port map(HX=>d3, SSD=>output(20 downto 14));
instan14: counter port map(Reset=>reset0,Clkin=>clk0,Clkout=>clk1);
instan15: bcd port map(x=>digout,y1=>d1,y2=>d2,y3=>d3);


end structrual;

