VERDI_SW = -P /home/shannon/synopsys/verdi/share/PLI/VCS/linux64/novas.tab \
		   /home/shannon/synopsys/verdi/share/PLI/VCS/linux64/pli.a

COV_SW = -cm line+cond+fsm+branch+tgl



vcs:
	@echo "Compiling !!!"
	vcs -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -sverilog -debug_acc+all  ${COV_SW} ${VERDI_SW} -f filelist.f -l compile.log 

run:
	@echo "Running Tests"
	./simv ${COV_SW} -l run.log

verdi:
	@echo "Look at the wave"
	verdi -f filelist.f -ssf *.fsdb & 
verdi_cov:
	@echo "Look at the coverage"
	verdi -cov -covdir simv.vdb&

clean:
	@echo "Clean!"
	rm -rf ucli.key simv csrc coverage simv.daidir *.fsdb *.conf *.log *.rc verdiLog *.vdb urgReport vc_hdrs.h *.cst DVEfiles vdCovLog
	
