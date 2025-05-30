require "mp.options"

-- Global variables

local our_opts = {
    enable = true,
    sub_forced_only = true
}

local event_init = true
local tas_init = true
local forced_flag = {}
local possible_forced_title = {}
local default_flag = {}
local other_subs = {}
local first_sub = {}
local forced_title_trans = {}
local user_sub_lang = {}
local selected_audio_lang = {}
local ret_i = 0

--

local function get_all_subs()
    local track_list = mp.get_property_native("track-list")
    local subcount = 0

    for i = 1, #track_list do
        if track_list[i].type == "sub" then
            subcount = subcount + 1

            if track_list[i].forced == true then
                table.insert(forced_flag, {track_list[i].id, track_list[i].lang, track_list[i].title})
            end

            if track_list[i].forced == false and track_list[i].title ~= nil then
                table.insert(possible_forced_title, {track_list[i].id, track_list[i].lang, track_list[i].title})
            end

            if track_list[i].forced == false and track_list[i].default == true then
                table.insert(default_flag, {track_list[i].id, track_list[i].lang, track_list[i].title})
            end

            if track_list[i].forced == false and track_list[i].default == false then
                table.insert(other_subs, {track_list[i].id, track_list[i].lang, track_list[i].title})
            end

            if subcount == 1 then
                table.insert(first_sub, {track_list[i].id, track_list[i].lang, track_list[i].title})
            end
        end
    end

    if subcount == 0 then
        return false
    else
        return true
    end
end

local function select_sid(sid, ssby, slang, stitle)
    local title, lang

    if mp.get_property_number("current-tracks/sub/id") ~= sid then
        mp.set_property_number("sid", sid)
    end

    print("Selected subtitle by: "..ssby)
    if stitle then
        title = " '"..stitle.."'"
    end
    if slang then
        lang = " ("..slang..")"
    end
    if title and lang then
        print("Displaying subtitle ID "..sid..title..lang)
    elseif title and not lang then
        print("Displaying subtitle ID "..sid..title)
    elseif not title and lang then
        print("Displaying subtitle ID "..sid..lang)
    else
        print("Displaying subtitle ID "..sid)
    end

    -- Reset global tables
    forced_flag = {}
    possible_forced_title = {}
    default_flag = {}
    other_subs = {}
    first_sub = {}
    forced_title_trans = {}
    user_sub_lang = {}
    selected_audio_lang = {}
end

local function get_forced_title_trans()
    forced_title_trans = {
        afr="gedwonge",alb="të detyruar",amh="የግዳጅ",ara="القسرية",arm="հարկադիր",
        asm="জোৰকৈ", aym="forzado",aze="məcburi",bam="fanga la",baq="behartua", bel="прымусовыя",
        ben="জোর করে",bho="जबरन",bos="prisilni",bul="принудени",cat="forçat",ceb="pinugos nga",
        nya="mokakamiza",chi="强制",zho="強製",cos="forzatu",hrv="prisilni",cze="vynucený",
        dan="tvungen",div="މަޖުބޫރުކޮށްގެން",doi="जबरन",dut="geforceerde",eng="forced",epo="devigita",
        est="sunnitud",ewe="wozi ame dzi",fil="sapilitang",fin="pakotettu",fre="forcé",
        fry="twongen",glg="forzados",qeo="იძულებითი",ger="erzwungener",gre="αναγκαστικός",
        grn="forzado",guj="ફરજિયાત",hat="fòse",hau="tilasta",haw="paʻa",heb="כפויה",
        hin="जबरन",hmn="yuam",hun="kényszerű",ice="þvingaður",ibo="mmanye",ilo="napilit",
        ind="paksa",gle="éigean",ita="forzato",jpn="強制",jav="dipeksa",kan="ಬಲವಂತದ",
        kaz="мәжбүрлі",khm="ងដោយបង្ខំ",kin="gahato",kok="जबरदस्तीन",kor="강제",kri="fos",
        kur="zorê",ku="زۆرەملێ",kir="мажбурлап",lao="ບັງຄັບ",lat="coactus",lav="piespiedu",
        lin="ya makasi",lit="priverstinis",lug="okukaka",ltz="gezwongen",mac="принуден",
        mai="जबरदस्ती",mlg="an-tery",may="paksa",mal="നിർബന്ധിത",mlt="sfurzat",mao="takoha",
        mar="सक्तीचे",mni="ꯐꯣꯔꯁ ꯇꯧꯔꯕꯥ",lus="nawr luih tir a ni",mon="албадан",bur="အတင်းအကြပ်",
        nep="जबरजस्ती",nor="tvungen",ori="ବାଧ୍ୟତାମୂଳକ",orm="dirqisiifame",pus="جبري",
        per="اجباری",pol="wymuszony",por="forçada",pan="ਜ਼ਬਰਦਸਤੀ",que="obligado",rum="forțată",
        rus="принудительные",smo="fa'amalosi",san="बलात्",gla="èiginneach",nso="kgapeletšo",
        srp="присилни",sot="qobelletsoeng",sna="kumanikidzwa",snd="زبردستي",sin="බලහත්කාර",
        slo="vynútený",slv="vsiljen",som="qasab",spa="forzado",sun="kapaksa",swa="kulazimishwa",
        swe="påtvingad",tgk="маҷбурӣ",tam="கட்டாய",tat="мәҗбүри",tel="బలవంతంగా",tha="ายบังคับ",
        tir="ግዱድ",tso="ku sindzisiwa",tur="zorunlu",tuk="mejbury",twi="wɔhyɛ",ukr="примусові",
        urd="زبردستی",uig="مەجبۇر",uzb="majburiy",vie="bắt buộc",wel="gorfodol",
        xho="esinyanzelweyo",yid="געצווונגען",yor="fi agbara mu",zul="ophoqelelwe"
    }
end

local function is_matching_lang(src_lang, sub_table)
    --[[
    src_lang:
        1 = user desired sub lang
        2 = media audio lang
    --]]

    -- First: search the exact language code
    if src_lang == 1 then
        for i = 1, #sub_table do
            for j = 1, #user_sub_lang do
                if user_sub_lang[j] and sub_table[i][2] then
                    if string.lower(user_sub_lang[j]) == string.lower(sub_table[i][2]) then
                        return i
                    end
                end
            end
        end
    else
        for i = 1, #sub_table do
            if sub_table[i][2] then
                if string.lower(selected_audio_lang) == string.lower(sub_table[i][2]) then
                    return i
                end
            end
        end
    end

    -- Second: search the code in character strings
    if src_lang == 1 then
        local user_sub_lang_extracted

        for i = 1, #sub_table do
            for j = 1, #user_sub_lang do
                if user_sub_lang[j] and sub_table[i][2] then
                    if string.find(user_sub_lang[j], "-") then
                        user_sub_lang_extracted = string.sub(user_sub_lang[j], 1, 2) -- Extract the 2 first characters
                    else
                        user_sub_lang_extracted = user_sub_lang[j]
                    end

                    if string.find(string.lower(sub_table[i][2]), string.lower(user_sub_lang_extracted)) then
                        return i
                    end
                end
            end
        end
    else
        local selected_audio_lang_extracted

        if string.find(selected_audio_lang, "-") then
            selected_audio_lang_extracted = string.sub(selected_audio_lang, 1, 2) -- Extract the 2 first characters
        else
            selected_audio_lang_extracted = selected_audio_lang
        end

        for i = 1, #sub_table do
            if sub_table[i][2] then
                if string.lower(selected_audio_lang_extracted) == string.lower(sub_table[i][2]) then
                    return i
                end
            end
        end
    end

    return 0
end

local function search_forced_sub()
    user_sub_lang = mp.get_property_native("slang")
    local forced_title = {}

    local function found_lang_forced_flag(sid, slang, stitle)
        select_sid(sid, "Forced flag (with matching language)", slang, stitle)
    end

    local function found_lang_forced_title(sid, slang, stitle)
        select_sid(sid, "Forced track name (with matching language)", slang, stitle)
    end

    local function found_lang_audio_forced_flag(sid, slang, stitle)
        select_sid(sid, "Forced flag (with matching audio language)", slang, stitle)
    end

    local function found_lang_audio_forced_title(sid, slang, stitle)
        select_sid(sid, "Forced track name (with matching audio language)", slang, stitle)
    end

    local function found_nolang_forced_flag(sid, slang, stitle)
        select_sid(sid, "Forced flag (without matching language)", slang, stitle)
    end

    local function found_nolang_forced_title(sid, slang, stitle)
        select_sid(sid, "Forced track name (without matching language)", slang, stitle)
    end

    if #forced_flag > 0 then
        if user_sub_lang[1] then
            ret_i = is_matching_lang(1, forced_flag)
            if ret_i ~= 0 then
                found_lang_forced_flag(forced_flag[ret_i][1], forced_flag[ret_i][2], forced_flag[ret_i][3])
                return true
            end
        end
    end

    if #possible_forced_title > 0 then
        get_forced_title_trans()

        for i = 1, #possible_forced_title do
            for _,value in pairs(forced_title_trans) do
                if possible_forced_title[i][3] then
                    if string.find(string.lower(possible_forced_title[i][3]), string.lower(value)) then
                        table.insert(forced_title, {possible_forced_title[i][1], possible_forced_title[i][2], possible_forced_title[i][3]})
                        if user_sub_lang[1] then
                            ret_i = is_matching_lang(1, forced_title)
                            if ret_i ~= 0 then
                                found_lang_forced_title(forced_title[ret_i][1], forced_title[ret_i][2], forced_title[ret_i][3])
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    if mp.get_property_bool("current-tracks/audio/selected") then
        selected_audio_lang = mp.get_property("current-tracks/audio/lang")

        if selected_audio_lang then
            if #forced_flag > 0 then
                ret_i = is_matching_lang(2, forced_flag)
                if ret_i ~= 0 then
                    found_lang_audio_forced_flag(forced_flag[ret_i][1], forced_flag[ret_i][2], forced_flag[ret_i][3])
                    return true
                end
            end

            if #forced_title > 0 then
                ret_i = is_matching_lang(2, forced_title)
                if ret_i ~= 0 then
                    found_lang_audio_forced_title(forced_title[ret_i][1], forced_title[ret_i][2], forced_title[ret_i][3])
                    return true
                end
            end
        end
    end

    if #forced_flag > 0 then
        found_nolang_forced_flag(forced_flag[1][1], forced_flag[1][2], forced_flag[1][3])
        return true
    elseif #forced_title > 0 then
        found_nolang_forced_title(forced_title[1][1], forced_title[1][2], forced_title[1][3])
        return true
    else
        return false
    end
end

local function search_non_forced_sub()
    local function found_lang_default_flag(sid, slang, stitle)
        select_sid(sid, "Default flag (with matching language)", slang, stitle)
    end

    local function found_lang(sid, slang, stitle)
        select_sid(sid, "First subtitle (with matching language)", slang, stitle)
    end

    local function found_lang_audio(sid, slang, stitle)
        select_sid(sid, "First subtitle (with matching audio language)", slang, stitle)
    end

    local function found_nolang_default_flag(sid, slang, stitle)
        select_sid(sid, "Default flag (without matching language)", slang, stitle)
    end

    local function found_first_id(sid, slang, stitle)
        select_sid(sid, "First ID", slang, stitle)
    end

    if user_sub_lang[1] then
        if #default_flag > 0 then
            ret_i = is_matching_lang(1, default_flag)
            if ret_i ~= 0 then
                found_lang_default_flag(default_flag[ret_i][1], default_flag[ret_i][2], default_flag[ret_i][3])
                return true
            end
        end

        if #other_subs > 0 then
            ret_i = is_matching_lang(1, other_subs)
            if ret_i ~= 0 then
                found_lang(other_subs[ret_i][1], other_subs[ret_i][2], other_subs[ret_i][3])
                return true
            end
        end
    end

    if selected_audio_lang then
        local function merge_tables(t1, t2)
            local t3 = {}

            for _,v in ipairs(t1) do
                table.insert(t3, v)
            end

            for _,v in ipairs(t2) do
                table.insert(t3, v)
            end

            return t3
        end

        local all_non_forced = merge_tables(default_flag, other_subs)

        if #all_non_forced > 0 then
            ret_i = is_matching_lang(2, all_non_forced)
            if ret_i ~= 0 then
                found_lang_audio(all_non_forced[ret_i][1], all_non_forced[ret_i][2], all_non_forced[ret_i][3])
                return true
            end
        end
    end

    if #default_flag > 0 then
        found_nolang_default_flag(default_flag[1][1], default_flag[1][2], default_flag[1][3])
        return true
    end

    if #first_sub > 0 then
        found_first_id(first_sub[1][1], first_sub[1][2], first_sub[1][3])
        return true
    end

    return false
end

local function main()
    if get_all_subs() then
        if search_forced_sub() then
            mp.set_property_bool("sub-forced-events-only", false)
            return
        elseif our_opts.sub_forced_only then
            if mp.get_property_bool("current-tracks/sub/selected") then
                mp.set_property("sid", "no")
            end
            print("Not found only forced subtitles, try with --script-opts=afs-sub_forced_only=no")
            return
        else
            search_non_forced_sub()
            mp.set_property_bool("sub-forced-events-only", false)
        end
    else -- No subs, bye
        return
    end
end

local function on_update_our_opts(list)
    if list.enable and our_opts.enable then
        mp.register_event("file-loaded", main)

        if mp.get_property_bool("track-auto-selection") then
            if event_init then
                event_init = false
            else
                print("Script enabled")
            end
        else
            mp.set_property_bool("track-auto-selection", true)
            print("track-auto-selection and script enabled")
        end
    end

    if list.enable and not our_opts.enable then
        mp.unregister_event(main)

        if event_init then
            event_init = false
        else
            print("Script disabled")
        end
    end

    if list.sub_forced_only and our_opts.sub_forced_only then
        print("Only forced subtitles enabled")
    end

    if list.sub_forced_only and not our_opts.sub_forced_only then
        print("Only forced subtitles disabled")
    end
end

local function on_update_tas(prop_name, value)
    if tas_init then -- Skip initial change notification
        tas_init = false
        return
    end

    if not value and our_opts.enable then
        mp.commandv("change-list", "script-opts", "append", "afs-enable=no")
    end
end

-- Startup
read_options(our_opts, "afs", function(list) on_update_our_opts(list) end)

if  our_opts.enable and
    mp.get_property_bool("track-auto-selection") and
    mp.get_property("sid") == "auto"
then
    on_update_our_opts({enable=true})
elseif not our_opts.enable then -- For event_init only
    our_opts.enable = false
    on_update_our_opts({enable=true})
else -- For event_init only
    mp.commandv("change-list", "script-opts", "append", "afs-enable=no") -- Ran async
end

mp.observe_property("track-auto-selection", "bool", on_update_tas)
