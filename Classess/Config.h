//
//  Config.h
//  WoundEZ
//
//  Created by sathish kumar on 10/5/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//
#import "AppDelegate.h"

#define ArtMap_DELEGATE              ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ArtMapUSER_DEFAULTS          [NSUserDefaults standardUserDefaults]
#define ArtMapVIEW_FRAME             [UIScreen mainScreen] applicationFrame]

#define BASE_URL       @"http://54.200.29.107/mapshot/"

#define IMG_BASE_URL    @"http://54.200.29.107/"

#define ImagebaseUrl    @"http://54.200.29.107/"


#define DefaultHudText  @"Please wait.."

#define forgetPassWordUrl  BASE_URL@"index.php/api/webcall/user_forgetpassword/format/json"

#define ChangePasswordUrl  BASE_URL@"index.php/api/webcall/user_changepassword/format/json"

#define signOutService  BASE_URL@"index.php/api/webcall/user_signout/format/json"

#define imageNameUpdate  BASE_URL@"index.php/api/webcall/imagenameupdate/format/json"


#define ArtMapRegister  BASE_URL@"index.php/api/webcall/user_register/format/json"

#define ArtMapLikedCommentimage             BASE_URL@"index.php/api/webcall/get_liked_images/format/json"


#define ArtMap_Multi_Image_Upload          BASE_URL@"index.php/api/webcall/multiimages/format/json"



#define ArtMap_Flag_Image                  BASE_URL@"index.php/api/webcall/insert_flag/format/json"

//check_push_status

#define Artmap_check_push_status         BASE_URL@"index.php/api/webcall/push_status/format/json"

#define ArtMap_Deactive_pushMsg            BASE_URL@"index.php/api/webcall/update_push_notification/format/json"

#define ArtMap_Push_Reset                 BASE_URL@"index.php/api/webcall/read_notification/format/json"


#define ArtMapCurrentUserFollowingUserImage    BASE_URL@"index.php/api/webcall/follow_images/format/json"


#define ArtMapLogin                         BASE_URL@"index.php/api/webcall/user_details/format/json"

#define ImagePost                           BASE_URL@"index.php/api/webcall/getimages/format/json"

#define DeleteUserAccount                   BASE_URL@"index.php/api/webcall/delete_profile/format/json"

#define DeactivateUserAccount                BASE_URL@"index.php/api/webcall/active_state_update/format/json"

#define ArtMapSigleimage                    BASE_URL@"index.php/api/webcall/single_image_upload/format/json"

#define ArtMapMultipleImageUpload           BASE_URL@"index.php/api/webcall/multi_upload_images/format/json"


#define ArtMapImagesDetails                 BASE_URL@"index.php/api/webcall/getimage_details/format/json"

#define ArtMapAddComments                   BASE_URL@"index.php/api/webcall/imagecomments/format/json"

#define ArtMapDeleteImage                   BASE_URL@"index.php/api/webcall/delete_image/format/json"

#define ArtMapImgaeLikes                    BASE_URL@"index.php/api/webcall/imagelike/format/json"

#define ArtMapCommentsLike                  BASE_URL@"index.php/api/webcall/imagecommentslike/format/json"
//
#define ArtMapProfileView                   BASE_URL@"index.php/api/webcall/profileview/format/json"

#define ArtMapProfileImgUpload              BASE_URL@"index.php/api/webcall/profileimage/format/json"

#define ArtMapFollow                        BASE_URL@"index.php/api/webcall/follow/format/json"

#define ArtMapGetFollow                     BASE_URL@"index.php/api/webcall/getfollow/format/json"

#define ArtMapAddDescription                BASE_URL@"index.php/api/webcall/addescription/format/json"

#define ArtMApGetNotification               BASE_URL@"index.php/api/webcall/display/format/json"


#define ArtMapNotificationState             BASE_URL@"index.php/api/webcall/notification_stat/format/json"

#define ArtMapSearchImagebytitle            BASE_URL@"index.php/api/webcall/titlesearch/format/json"

#define ArtMapTopimages                     BASE_URL@"index.php/api/webcall/getsorted/format/json"

#define ArtMapRecentTenimages               BASE_URL@"index.php/api/webcall/getrecent_ten_post/format/json"

#define ArtMap_UserId                       @"User_ID"
#define Artmap_Image                        @"Image"
#define ArtMap_detail                       @"ImageDetail"
#define ArtMap_Addcomments                  @"ADDCOMMENTS"

#define ArtMap_GEOLOCATION                  @"geoLocation"

#define ArtMap_FBid                         @"FBUser_id"
#define ArtMapPic                           @"Instagrampic"
#define ArtMapActionType                    @"ACTIONTYPE"
#define ArtMapFBType                        @"Facebook"
#define ArtMapSecondaryuserid               @"SECONDARYUserid"
#define ArtMapDeviceToken                   @"DeviceToken"
#define ArtMapUserActive                    @"ActiveOrNot"

#define ArtMapScreenShot                    @"ScreenShot"
#define ArtButtonEnableKey                  @"EnableKey"
#define ArtMapIscommentlike                 @"Commentlikes"
#define ArtMapPushStatus             @"push_status_on_off"
#define ArtMapAuthenticationUsername  @"innoppl"
#define ArtMapAuthenticationPassword  @"a1812c532969e017bc6f1fe88f477884"



#define LS_Log_Folder                [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/logs"]
#define LS_Log_History               [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/logs/history"]


#define LS_XMPP_FilePath             @"logs/XMPP_Logger"
#define LS_START_SESSIONTIME         @"START_SESSION_TIME"
#define LS_APP_LIVESESSIONTIME       @"APP_LIVE_SESSION_TIME"


#define LS_XMPP_Code                 @"XMPP_CODE"

#define testOk  @"TestOk"


#define DDSetUserDefault(value,key)     [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define DDGetUserDefaultForKey(key)     [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DDRemoveUserDefaultForKey(key)  [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];


typedef enum {
    AMLOGINTYPE_LOCAL             = 0,
    AMLOGINTYPE_FACEBOOK          = 1,
    AMLOGINTYPE_TWITTER           = 2,
    AMLOGINTYPE_INSTAGRAM         = 3
    
}AMLOGINTYPE;


typedef enum {
    
    webSERVICE_SIGNUP            = 0,
    webSERVICE_LOGIN             = 1,
    AMWSSERVICE_UPLOAD            = 2
    
}AMWSSERVICE;

typedef enum {
    
    ART_FOLLOWSTATUS_UNFOLLOW  = 0,
    ART_FOLLOWSTATUS_FOLLOW    = 1
    
}ART_FOLLOWSTATUS;


#define termsREAD  @"TermsRead"

//------------------------ Facebook -------------------------------------

#define redirectURL @"http://www.facebook.com/connect/login_success.html"

#define callBackURL @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch"

#define facebookAppID @"184595351730666"



#define extendedPermission @"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"


