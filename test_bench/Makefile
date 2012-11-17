LOGIC_INCPATH = ../logic/
LOGPATH = log/
VCDPATH = vcd/
FLAGS = -I$(LOGIC_INCPATH) -o
TARGET = test_reg_timer test_reg_alerm test_pulse_inc_cnt test_bus_sel

all:$(TARGET)

test_reg_timer:
	iverilog $(FLAGS) test_reg_timer test_reg_timer.v $(LOGIC_INCPATH)reg_timer.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_reg_alerm:
	iverilog $(FLAGS) test_reg_alerm test_reg_alerm.v $(LOGIC_INCPATH)reg_alerm.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_pulse_inc_cnt:
	iverilog $(FLAGS) test_pulse_inc_cnt test_pulse_inc_cnt.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_bus_sel:
	iverilog $(FLAGS) test_bus_sel test_bus_sel.v $(LOGIC_INCPATH)bus_sel.v

log:$(TARGET)
	./test_reg_timer > $(LOGPATH)test_reg_timer.log
	mv test_reg_timer.vcd $(VCDPATH)
	./test_reg_alerm > $(LOGPATH)test_reg_alerm.log
	mv test_reg_alerm.vcd $(VCDPATH)
	./test_pulse_inc_cnt > $(LOGPATH)test_pulse_inc_cnt.log
	mv test_pulse_inc_cnt.vcd $(VCDPATH)
	./test_bus_sel > $(LOGPATH)test_bus_sel.log
	mv test_bus_sel.vcd $(VCDPATH)

clean:
	rm -rf $(TARGET) $(LOGPATH)* $(VCDPATH)* *.vcd *.log
