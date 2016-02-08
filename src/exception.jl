import Base: showerror

type FunctionError <: Exception
    mod::Symbol
    name::Symbol
end
FunctionError(mod::Module, name::Symbol) = FunctionError(module_name(mod), name)

showerror(io::IO, ex::FunctionError) = print(io, "FunctionError: function $(ex.name) does not exist in module $(ex.mod)")

type OverrideError <: Exception
    old_sig::Signature
    new_sig::Signature
end

showerror(io::IO, ex::OverrideError) = print(io, "OverrideError: overriding signature $(ex.new_sig) must be the same or more general than $(ex.old_sig)")
