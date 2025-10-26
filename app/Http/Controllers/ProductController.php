<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;
use Inertia\Inertia;
class ProductController extends Controller
{
    //
    public function index(){
        $products = Product::where('user_id', auth()->id()) 
        ->latest()
        ->get();
        return Inertia::render('products/Index',compact('products'));

    }

    public function create(){
        return Inertia::render('products/Create');
    }

    public function store(Request $request){
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:255'
        ]);
        $data['user_id'] = auth()->id();
        Product::create($data);
        return redirect()->route('products.index')->with('message', 'Product created successfully');

    }
    public function edit(Product $product){
        return Inertia::render('products/Edit', compact('product'));
    }
    public function update(Request $request, Product $product){
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:255',

        ]);
        
        $product->update($data);

        
        return redirect()->route('products.index')->with('message', 'Produto adicionado com sucesso');

        
    }
}
