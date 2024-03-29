//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Library/CountCompare.v $
//	Version:	$Revision: 19632 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2009 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2009, Regents of the University of California
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

//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.v"
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CountCompare
//	Desc:		An efficient (=) comparison against a monotonic, binary
//				counter.  This module exploits the fact that we needn't actually
//				check EVERY bit to determine equality.  The output may be true
//				for inputs larger than the comparison value.
//	Params:		Width:	Sets the bitwidth of the input
//				Compare:The value to compare against
//	Author:		<a href="http://www.gdgib.www.gdgib.com
//	Version:	$Revision: 19632 $
//------------------------------------------------------------------------------
module	CountCompare(Count, TerminalCount);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				8,
							Compare =				8'hFF;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				CWidth =				`log2(Compare+1),
							CWidthCheck =			`max(CWidth,1);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Count;
	output					TerminalCount;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	wire	[CWidth-1:0]	CompareWire;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	CompareWire =							Compare;
	assign	TerminalCount =							Compare ? &(Count[CWidthCheck-1:0] | ~CompareWire) : 1'b1;
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
