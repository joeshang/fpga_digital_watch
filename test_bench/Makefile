LOGIC_INCPATH = ../logic/
LOGPATH = log/
VCDPATH = vcd/
FLAGS = -I$(LOGIC_INCPATH) -o
TARGET = test_control test_reg_timer test_reg_alerm test_pulse_inc_cnt test_pulse_maker test_alerm_comp test_bin2bcd

all:$(TARGET)

test_control:test_control.v $(LOGIC_INCPATH)control.v $(LOGIC_INCPATH)reg_timer.v $(LOGIC_INCPATH)reg_alerm.v \
	   	$(LOGIC_INCPATH)pulse_inc_cnt.v $(LOGIC_INCPATH)pulse_maker.v $(LOGIC_INCPATH)alerm_comp.v
	iverilog $(FLAGS) test_control test_control.v  $(LOGIC_INCPATH)control.v $(LOGIC_INCPATH)reg_timer.v $(LOGIC_INCPATH)reg_alerm.v \
	   	$(LOGIC_INCPATH)pulse_inc_cnt.v $(LOGIC_INCPATH)pulse_maker.v $(LOGIC_INCPATH)alerm_comp.v

test_reg_timer:test_reg_timer.v $(LOGIC_INCPATH)reg_timer.v $(LOGIC_INCPATH)pulse_inc_cnt.v
	iverilog $(FLAGS) test_reg_timer test_reg_timer.v $(LOGIC_INCPATH)reg_timer.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_reg_alerm:test_reg_alerm.v $(LOGIC_INCPATH)reg_alerm.v $(LOGIC_INCPATH)pulse_inc_cnt.v
	iverilog $(FLAGS) test_reg_alerm test_reg_alerm.v $(LOGIC_INCPATH)reg_alerm.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_pulse_inc_cnt:test_pulse_inc_cnt.v $(LOGIC_INCPATH)pulse_inc_cnt.v
	iverilog $(FLAGS) test_pulse_inc_cnt test_pulse_inc_cnt.v $(LOGIC_INCPATH)pulse_inc_cnt.v

test_pulse_maker:test_pulse_maker.v $(LOGIC_INCPATH)pulse_maker.v
	iverilog $(FLAGS) test_pulse_maker test_pulse_maker.v $(LOGIC_INCPATH)pulse_maker.v

test_alerm_comp:test_alerm_comp.v $(LOGIC_INCPATH)alerm_comp.v $(LOGIC_INCPATH)pulse_maker.v
	iverilog $(FLAGS) test_alerm_comp test_alerm_comp.v $(LOGIC_INCPATH)alerm_comp.v $(LOGIC_INCPATH)pulse_maker.v

test_bin2bcd:test_bin2bcd.v $(LOGIC_INCPATH)bin2bcd.v
	iverilog $(FLAGS) test_bin2bcd test_bin2bcd.v $(LOGIC_INCPATH)bin2bcd.v

log:$(TARGET)
	./test_control > $(LOGPATH)test_control.log
	mv test_control.vcd $(VCDPATH)
	./test_reg_timer > $(LOGPATH)test_reg_timer.log
	mv test_reg_timer.vcd $(VCDPATH)
	./test_reg_alerm > $(LOGPATH)test_reg_alerm.log
	mv test_reg_alerm.vcd $(VCDPATH)
	./test_pulse_inc_cnt > $(LOGPATH)test_pulse_inc_cnt.log
	mv test_pulse_inc_cnt.vcd $(VCDPATH)
	./test_pulse_maker > $(LOGPATH)test_pulse_maker.log
	mv test_pulse_maker.vcd $(VCDPATH)
	./test_alerm_comp > $(LOGPATH)test_alerm_comp.log
	mv test_alerm_comp.vcd $(VCDPATH)
	./test_bin2bcd > $(LOGPATH)test_bin2bcd.log
	mv test_bin2bcd.vcd $(VCDPATH)

clean:
	rm -rf $(TARGET) $(LOGPATH)* $(VCDPATH)* *.vcd *.log
