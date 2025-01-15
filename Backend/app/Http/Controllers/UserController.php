<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\File;

class UserController extends Controller
{
    public function register(Request $request)
    {
        //validasi
        $request->validate([
            'nama' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string',
            'telp' => 'required|string|unique:users',
            'tanggal_lahir' => 'required',
            'foto' => 'nullable|string|max:255',
        ]);

        $fotoPath = $request->foto ? $request->foto : 'profile/default.png';  // Menggunakan foto default jika tidak ada foto yang diupload
    
    
        //create user
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'telp' => $request->telp,
            'tanggal_lahir' => $request->tanggal_lahir,
            'foto' => $fotoPath,
        ]);

        return response()->json([
            'user' => $user,
            'message' => 'User  registered sucessfully',
        ], 201, [], JSON_UNESCAPED_SLASHES);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $token = $user->createToken('Personal Access Token')->plainTextToken;

        return response()->json([
            'detail' => $user,
            'token' => $token
        ]);
    }

    public function logout(Request $request)
    {   
        if (Auth::check()){
            $request->user()->currentAccessToken()->delete();

            return response()->json(['message' => 'Logged out successfully']);
        }

        return response()->json(['message' => 'Not logged in'], 401);
        
    }

    public function index()
    {   
        $userId = Auth::id();

        $allUser = User::find($userId);
        return response()->json($allUser);
    }

    public function update(Request $request)
    {   
        $userId = Auth::id();

        $user = User::find($userId);

        if (!$user || $user->id != $userId) {
            return response()->json(['message' => 'User tidak ditemukan'], 403);
        }

        $validatedData = $request->validate([
            'nama' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,' .  $userId,
            'password' => 'nullable|string',
            'telp' => 'required|string|unique:users,telp,' . $userId,
            'tanggal_lahir' => 'nullable',
            'foto' => 'nullable|string|max:255',
        ]);

        if ($request->hasFile('foto')) {
            $fotoPath = $request->file('foto')->store('profile', 'public');
            $user->foto = $fotoPath;  
        }    

        if ($request->has('password') && !empty($request->password)) {
            $user->password = Hash::make($request->password);
        }

        $user->update($validatedData);

        return response()->json([
            'message' => 'Berhasil mengupdate User',
            'post' => $user,
        ], 200);
    }   

    public function updateFoto(Request $request)
    {
        try {
            $userId = Auth::id();
            $user = User::find($userId);
    
            if (!$user || $user->id != $userId) {
                return response()->json(['message' => 'User tidak ditemukan'], 403);
            }
    
            $validatedData = $request->validate([
                'foto' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            if ($user->foto !== 'profile/default.png') {
                File::delete(public_path($user->foto));
            }

            $destinationPath = public_path('profile');
            $fotoFile = $request->file('foto');
            $fotoName = 'foto-' . time() . '.' . $fotoFile->getClientOriginalExtension();
            $fotoFile->move($destinationPath, $fotoName);
    
            $user->update([
                'foto' => 'profile/' . $fotoName,
            ]);
    
            return response()->json([
                'user' => $user,
                'message' => 'Update foto profil berhasil!',
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Gagal memperbarui foto'], 500);
        }
    }
    

    public function destroy()
    {
        $userId = Auth::id();

        $user = User::find($userId);

        if (!$user || $user->id != $userId) {
            return response()->json(['message' => 'User tidak ditemukan'], 403);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil di hapus.']);
    }
}
