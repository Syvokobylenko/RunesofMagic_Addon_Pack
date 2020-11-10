--[[  OO Versuch ;) ]]


local SR = { };
_G["StatRating"] = SR;

SR.classes = { }
SR.config = nil;
SR.constants = { };
SR.db = nil;
SR.cacheDB = { };
SR.currentClass = nil;

function SR:NewClass( baseClass )

    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create(...)
        local newinst = {}
        setmetatable( newinst, class_mt );
        if newinst.init then
            newinst:init(...)
        end
        return newinst;
    end;

    if nil ~= baseClass then
        setmetatable( new_class, { __index = baseClass } );
    end;

    -- Return the class object of the instance
    function new_class:class()
        return new_class;
    end;

    -- Return the super class object of the instance
    function new_class:superClass()
        return baseClass;
    end;

    -- Return true if the caller is an instance of theClass
    function new_class:isa( theClass )
        local b_isa = false;

        local cur_class = new_class;

        while ( nil ~= cur_class ) and ( false == b_isa ) do
            if cur_class == theClass then
                b_isa = true;
            else
                cur_class = cur_class:superClass();
            end;
        end;

        return b_isa;
    end;

    return new_class;
end;

SR.classes.AbstractClass = SR:NewClass(nil);

SR.classes.TooltipParser = SR:NewClass(AbstractClass);

function SR.classes.TooltipParser:init(...)
  local tooltip = ...;
  self.tooltip = tooltip;
  self.tbl_sumStats = { };
end
