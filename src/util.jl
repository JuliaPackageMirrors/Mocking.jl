"""
    isgeneric(f::Function) -> Bool

Determine whether a Function is generic. Note that as of Julia 0.5 all functions are generic
and this function only exists to support compatibility with older versions.
"""
function isgeneric(f::Function)
    isa(f, Function) && (!isdefined(f, :env) || isa(f.env, MethodTable))
end

function module_and_name(m::Method)
    if isa(m.func, Function)
        mod = m.func.code.module
        name = m.func.code.name
    else
        mod = m.func.module
        name = m.func.name
    end
    return mod, name
end

function ignore_stderr(body::Function)
    # TODO: Need to figure out what to do on Windows...
    @windows_only return body()

    stderr = Base.STDERR
    null = open("/dev/null", "w")
    redirect_stderr(null)
    try
        return body()
    catch
        # Note: Catch runs prior to finally but errors seem to display fine
        rethrow()
    finally
        redirect_stderr(stderr)
    end
end

# Based upon Base.to_tuple_type(::ANY)
function to_array_type(t::ANY)
    if isa(t, Tuple) || isa(t, AbstractArray) || isa(t, SimpleVector)
        return Type[t...]
    else
        error("argument tuple type must contain only types")
    end
end
