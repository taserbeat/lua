#summary Mupen64-rr EmuLua Reference

# emu.frameadvance について

emu.frameadvance は現在実装されていません。
が、コルーチンとコールバックを組み合わせることで相当の関数が作れます。

```
function main()
	-- ここにemu.frameadvanceを使ったコードを書く
	-- 計算を止めるにはreturnをすれば良い
	-- 以下例
	local i = 0
	while true do
		print(i)
		i = i + 1
		emu.frameadvance()
		if i == 60 then return end
	end
end

main_wrap = coroutine.wrap(main)
function emu.frameadvance()
	coroutine.yield("frameadvance")
end
emu.atinput(function()
	if main_wrap and not main_wrap() then
		main_wrap = nil
	end
end)
```

# Reference

---

<font color='#DD0000'>
<a href='http://wiki.emulua.com/wiki/Main_Page'>他のエミュレータにも存在する関数</a>以外は、頻繁に仕様が変わったり、削除されたりする場合があります。**<br>
</font>**

---

| **表記**     | **type()** | **Lua API** | **詳細**       |
| :----------- | :--------- | :---------- | :------------- |
| **T...**     | ---        |             | 複数の任意の型 |
| **int**      | "number"   | lua_Integer | 整数値         |
| **number**   | "number"   | lua_Number  |                |
| **bool**     | "boolean"  |             |                |
| **function** | "function" |             |                |
| **table**    | "table"    |             |                |

---

**print(T... args)**

Lua コンソールに args を出力します。

string 型でない場合は tostring() により自動的に変換します。

---

**printx(T... args)**

number 型の場合は 16 進数に変換されます。

---

**string tostringex(T... args)**

args をタブで区切った文字列に変換します。

---

**int AND(int lhs, int rhs)**

---

**int OR(int lhs, int rhs)**

---

**int XOR(int lhs, int rhs)**

---

**int NOT(int operand)**

---

**int SHIFT(int n, int shift)**

---

**int BITS(int n, int x, int y)**

## <a href='Hidden comment:

MTC1(number n)

---

DMTC1(number n)

---

MFC1(number n)

---

DMFC1(number n)

---

CVT_D_L(number n)

'></a>

---

#### emulator

**emu.console(string message)**

Lua コンソールに message を出力

---

**emu.debugview(string message)**

DebugView に message を出力

---

**emu.statusbar(string message)**

ステータスバーに message を出力

---

**emu.atvi(function f, bool unregister)**

---

**emu.atupdatescreen(function f, bool unregister)**

---

**emu.atinput(function f, bool unregister)**

---

**emu.atstop(function f, bool unregister)**

---

**emu.atwindowmessage(function f, bool unregister)**

---

**emu.atinterval(function f, bool unregister)**

---

**int emu.framecount()**

現在のフレーム数を返す。

no movie 時の仕様は未定義

---

**int emu.samplecount()**

---

**int emu.inputcount()**

入力のあったフレーム数を返す。

---

**emu.pause()**

エミュレーションを一時停止する。

---

**bool emu.getpause()**

エミュレーションが一時停止していれば true そうでなければ false を返す。

---

**int emu.getspeed()**

エミュレーション速度を返す。

---

**emu.speed(int speed)**

エミュレーション速度を設定する。

---

**emu.speedmode(string mode)**

エミュレーション速度のモードを設定する。

**mode**: 以下の文字列

- normal
- maximum

---

**emu.getaddress(string type)**

**type**: 以下の文字列(大文字と小文字の区別は行わない)

- rdram
- rdram_register
- MI_register
- pi_register
- sp_register
- rsp_register
- si_register
- vi_register
- ai_register
- dpc_register
- dps_register
- DP_DMEM
- PIF_RAM

---

#### memory functions

<a href='Hidden comment:
_memory.LBU()_

---

_memory.LB()_

---

_memory.LHU()_

---

_memory.LH()_

---

_memory.LWU()_

---

_memory.LW()_

---

_memory.LDU()_

---

_memory.LD()_

---

_memory.LWC1()_

---

_memory.LDC1()_

---

_memory.loadsize()_

---

_memory.loadbytes()_

---

_memory.loadhalfs()_

---

_memory.loadwords()_

---

_memory.SB()_

---

_memory.SH()_

---

_memory.SW()_

---

_memory.SD()_

---

_memory.SWC1()_

---

_memory.SDC1()_

'></a>

## <a href='Hidden comment:

_memory.storesize()_

---

_memory.syncbreak()_

---

_memory.pcbreak()_

---

_memory.readbreak()_

---

_memory.writebreak()_

---

_memory.reg()_

---

_memory.getreg()_

---

_memory.setreg()_

---

_memory.trace()_

---

_memory.tracemode()_

---

_memory.getcore()_

---

_memory.recompilenow()_

---

_memory.recompile()_

---

_memory.recompilenext()_

---

_memory.recimpilenextall()_

'></a>

## <a href='Hidden comment:

_memory.readmemb()_

---

_memory.readmemh()_

---

_memory.readmem()_

---

_memory.readmemd()_

---

_memory.writememb()_

---

_memory.writememh()_

---

_memory.writemem()_

---

_memory.writememd()_

'></a>

---

**int memory.readbytesigned(int address)**

指定されたアドレスから、符号付き 1byte を読み取ります。

---

**int memory.readbyte(int address)**

指定されたアドレスから、符号なし 1byte を読み取ります。

---

**int memory.readwordsigned(int address)**

指定されたアドレスから、符号付き 2byte を読み取ります。

---

**int memory.readword(int address)**

指定されたアドレスから、符号なし 2byte を読み取ります。

---

**int memory.readdwordsigned(int address)**

指定されたアドレスから、符号付き 4byte を読み取ります。

---

**int memory.readdword(int address)**

指定されたアドレスから、符号なし 4byte を読み取ります。

---

**table<int, int> memory.readqwordsigned(int address)**

指定されたアドレスから、符号付き 8byte を読み取ります。

---

~~**memory.readqword(int address)**~~

~~指定されたアドレスから、符号なし 8byte を読み取ります。~~

---

**number memory.readfloat(int address)**

指定されたアドレスから、単精度浮動小数点数を読み取ります。

---

**number memory.readdouble(int address)**

指定されたアドレスから、倍精度浮動小数点数を読み取ります。

---

**int memory.readsize(int address, int size)**

**number memory.readsize(int address, int size)**

指定されたアドレスから、引数 size byte 分の値を読み取ります。

**size**: 1, 2, 4, 8 のいずれか
これ以外の値が渡された場合はエラーになります。

---

**table memory.readbyterange(int address, int size)**

指定されたアドレスから、1byte ずつ size 分の値を読み取ります。

**return**: 符号なし 1byte の配列

---

**memory.writebyte(int address, int value)**

指定されたアドレスに、1byte の値を書き込みます。

---

**memory.writeword(int address, int value)**

指定されたアドレスに、2byte の値を書き込みます。

---

**memory.writedword(int address, int value)**

指定されたアドレスに、4byte の値を書き込みます。

---

~~**memory.writelong(int address, int value)**~~

~~指定されたアドレスに、4byte の値を書き込みます。~~

---

**memory.writeqword(int address, int value)**

指定されたアドレスに、8byte の値を書き込みます。

---

**memory.writefloat(int address, number value)**

指定されたアドレスに、単精度浮動小数点数を書き込みます。

---

**memory.writedouble(int address, number value)**

指定されたアドレスに、倍精度浮動小数点数を書き込みます。

---

**memory.writesize(int address, int size, int value)**

**memory.writesize(int address, int size, number value)**

指定されたアドレスに、引数 size byte 分の値を書き込みます。

size には 1, 2, 4, 8 のいずれかを指定してください。
それ以外の値が渡された場合はエラーになります。

---

#### gui

**gui.register(function f)**

**gui.register(function f, bool unregister)**

関数 f を画面更新時に呼び出す関数テーブルに登録します。

unregister に true が指定された場合、テーブルから削除します。

---

#### wgui

**wgui.setbrush()**

---

**wgui.setpen()**

---

**wgui.setcolor()**

---

**wgui.setbk()**

---

**wgui.setfont()**

---

**wgui.text()**

---

**wgui.drawtext()**

---

**wgui.rect()**

---

**wgui.elipse()**

---

**wgui.plygon()**

---

**wgui.line()**

---

**wgui.info()**

---

**wgui.resize()**

---

#### input

#### input table keys

この配列の順序は Lua に取っては無意味なので、あとで整形する

```
const char* KeyName[256] =
{
	NULL, "leftclick", "rightclick", NULL,
	"middleclick", NULL, NULL, NULL,
	"backspace", "tab", NULL, NULL,
	NULL, "enter", NULL, NULL,
	"shift", "control", "alt", "pause", // 0x10
	"capslock", NULL, NULL, NULL,
	NULL, NULL, NULL, "escape",
	NULL, NULL, NULL, NULL,
	"space", "pageup", "pagedown", "end", // 0x20
	"home", "left", "up", "right",
	"down", NULL, NULL, NULL,
	NULL, "insert", "delete", NULL,
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
	"U", "V", "W", "X", "Y", "Z",
	NULL, NULL, NULL, NULL, NULL,
	"numpad0", "numpad1", "numpad2", "numpad3", "numpad4", "numpad5", "numpad6", "numpad7", "numpad8", "numpad9",
	"numpad*", "numpad+",
	NULL,
	"numpad-","numpad.","numpad/",
	"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",
	"F13","F14","F15","F16","F17","F18","F19","F20","F21","F22","F23","F24",
	NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
	"numlock", "scrolllock",
	NULL, // 0x92
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, // 0xB9
	"semicolon", "plus", "comma", "minus",
	"period", "slash", "tilde",
	NULL, // 0xC1
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, // 0xDA
	"leftbracket", "backslash", "rightbracket", "quote",
};
```

上記に加えて: "xmouse", "ymouse"

---

**table input.get()**

現在入力されているキー,マウスを取得します。

**return**: 入力中のキーの名前と bool 値のテーブル

---

**input.diff()**

---

**input.prompt()**

---

#### joypad input keys

X, Y, L, R, Cup, Cdown, Cleft, Cright, A, B, Z, start, up, down, left, right

**joypad.get(int player = 1)**

現在入力されているボタンを取得します。

**player**: コントローラポート 1,2,3,4

**return**:

> 入力中のボタンの名前と bool 値のテーブル
> X, Y は符号付き 1byte の数値

---

**joypad.set(int player = 1, table input)**

**player**: コントローラポート 1,2,3,4

**input**:

> 入力中のボタンの名前と bool 値のテーブル
> X, Y は符号付き 1byte の数値

---

**joypad.register()**

---

**joypad.count()**

---

**savestate.savefile(string path)**

指定されたファイルに現在の状態を保存します。

---

**savestate.loadfile(string path)**

指定されたファイルから状態を復元します。

---
