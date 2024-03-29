//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFORegister.v $
//	Version:	$Revision: 26904 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORegister
//	Desc:		A class1 or class2 FIFO implementation which is one deep.  Has
//				zero/one cycle forward latency, one fragment of buffering, and
//				zero/one cycle backwards latency (RDL channel
//				CBFC<Width, FWLatency, 1, BWLatency>). This module will be
//				class1 only if FWLantency = BWLatency = 1.
//	Params:		Width:	The width of the data through this FIFO.
//				FWLatency: The forward latency through this FIFO.
//				BWLatency: The backwards latency through this FIFO.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 26904 $
//------------------------------------------------------------------------------
module	FIFORegister(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							FWLatency =				1,
							BWLatency =				0,
							Initial =				{Width{1'bx}},
							InitialValid =			1'b0,
							ResetValue =			{Width{1'b0}},
							ResetValid =			1'b0,
							Conservative =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Data;
	wire					Full;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	OutData =								(FWLatency || Full) ? Data : InData;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Value Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.ResetValue(		ResetValue))
					Value(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			(Conservative ? InValid : 1'b1) & InAccept),
								.In(				InData),
								.Out(				Data));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Controller
	//--------------------------------------------------------------------------
	FIFORegControl	#(			.FWLatency(			FWLatency),
								.BWLatency(			BWLatency),
								.InitialValid(		InitialValid),
								.ResetValid(		ResetValid))
					Cntrl( 		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutSend(			OutSend),
								.OutReady(			OutReady),
								.Full(				Full));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------
