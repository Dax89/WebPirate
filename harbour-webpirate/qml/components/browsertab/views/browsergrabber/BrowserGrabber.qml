import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../items/cover"
import "../../../items"

Item
{
    property ListModel videoList: ListModel { }
    property bool grabbing: false
    property bool grabFailed: false
    property string grabStatus

    property alias videoTitle: grabberthumbnail.title
    property alias videoAuthor: grabberthumbnail.author
    property alias videoThumbnail: grabberthumbnail.source
    property alias videoDuration: grabberthumbnail.duration

    function addVideo(info, mime, url) {
        videoList.append( {"videoinfo": info, "videomime": mime, "videourl": url });
    }

    function clearVideos() {
        videoList.clear();
    }

    id: browsergrabber

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingSmall

            GrabberThumbnail { id: grabberthumbnail; width: parent.width }

            Label
            {
                id: lblgrabstatus
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: "<font color='" + Theme.highlightColor + "'>" + qsTr("Status") + ": </font>" + grabStatus;
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                wrapMode: Text.Wrap

                color: {
                    if(!grabbing && !grabFailed)
                        return "lime";

                    if(grabFailed)
                        return "red";

                    return Theme.primaryColor;
                }
            }

            Repeater
            {
                id: videorepeater
                model: browsergrabber.videoList

                delegate: GrabberItem {
                    contentWidth: browsergrabber.width
                    contentHeight: Theme.itemSizeSmall
                    videoInfo: model.videoinfo
                    videoUrl: model.videourl
                    videoThumbnail: grabberthumbnail.source
                    videoTitle: grabberthumbnail.title
                }
            }
        }
    }

    PageCoverActions
    {
        id: pagecoveractions
        enabled: browsergrabber.visible
    }
}
